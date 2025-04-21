extends DirectionalLight3D

@export var worldEnvironment: WorldEnvironment
@export var nightLight: DirectionalLight3D
@export var rotationOffset: Vector3
var sky: ProceduralSkyMaterial

@export_group("Time")
@export var cutoffHour: float = 22.0
@export var currentTime: float = 480.0
@export var speedMultiplier: float = 1.0
@export var secondsPerMinute: float = 1.0
@export var dayLengthHours: int = 24
@export var dayLengthMinutes: int
@export var sunriseHour: int = 6
@export var sunsetHour: int = 18

@export_group("Lighting")
@export var dayLightEnergy: float = 1.0
@export var nightLightEnergy: float = 0.1

@export_group("Colors")
@export var transitionSpeed: float = 0.001
@export_subgroup("Sky")
@export var sunriseColor := Color("ffe752")
@export var dayColor := Color("cfbc81")
@export var sunsetColor := Color("ff57b1")
@export var nightColor := Color("23063e")

var currentColor: Color
var colorToLerp: Color

var daylightDuration: float
var totalGameMinutes: float
var myRotation: float

signal nightTime

## Use these to determine in-game time
var hours: int
var minutes: int

func _ready():
	# References
	sky = worldEnvironment.environment.sky.sky_material
	
	# Time and rotation
	totalGameMinutes = dayLengthHours * 60.0 + dayLengthMinutes
	daylightDuration = (sunsetHour - sunriseHour) * 60.0
	myRotation = 180.0 / daylightDuration
	
	update_clock()
	
	# Start settings
	if hours == sunriseHour: currentColor = sunriseColor
	elif hours > sunriseHour && hours < sunsetHour: currentColor = dayColor
	elif hours == sunsetHour: currentColor = sunsetColor
	elif (hours > sunsetHour && hours <= dayLengthHours) || (hours >= 0 && hours < sunriseHour): currentColor = nightColor
	colorToLerp = currentColor
	
	if hours >= sunriseHour && hours <= sunsetHour:
		light_energy = dayLightEnergy
		nightLight.light_energy = 0.0

	else:
		light_energy = 0.0
		nightLight.light_energy = nightLightEnergy
		
func _physics_process(delta):
	# Sun and moon rotation
	currentTime += delta / secondsPerMinute * speedMultiplier
	if currentTime >= totalGameMinutes: currentTime = 0.0
	
	var timeSinceSunrise: float = currentTime - sunriseHour * 60.0
	rotation_degrees = Vector3(timeSinceSunrise * myRotation + 180.0, 0.0, 0.0) + rotationOffset
	
	update_clock()
	
	# Sky color
	if hours == sunriseHour: currentColor = sunriseColor
	elif hours == sunriseHour + 1: currentColor = dayColor
	elif hours == sunsetHour - 1: currentColor = sunsetColor
	elif hours == sunsetHour: currentColor = nightColor
	
	var lerpSpeed: float = transitionSpeed * speedMultiplier
	colorToLerp = colorToLerp.lerp(currentColor, lerpSpeed)

	sky.sky_top_color = lerp(sky.sky_top_color, colorToLerp, lerpSpeed)
	sky.sky_horizon_color = lerp(sky.sky_horizon_color, colorToLerp, lerpSpeed)
	# sky.ground_bottom_color = lerp(colorToLerp, sky.ground_bottom_color, lerpSpeed)
	# sky.ground_horizon_color = lerp(colorToLerp, sky.ground_horizon_color,  lerpSpeed)
	
	if hours >= sunriseHour && hours <= sunsetHour - 1:
		# Lighting
		light_energy = lerp(light_energy, dayLightEnergy, lerpSpeed)
		nightLight.light_energy = lerp(nightLight.light_energy, 0.0, lerpSpeed)
	else:
		# Lighting
		light_energy = lerp(light_energy, 0.0, lerpSpeed)
		nightLight.light_energy = lerp(nightLight.light_energy, nightLightEnergy, lerpSpeed)
		
func update_clock():
	if GlobalInGame.player_UI:
		GlobalInGame.pass_time_to_UI(currentTime)
	hours = int(currentTime / 60)
	if (hours > cutoffHour):
		speedMultiplier = 0
		nightTime.emit()
		GlobalInGame.nighttime_starts.emit()
	minutes = int(currentTime) % 60
