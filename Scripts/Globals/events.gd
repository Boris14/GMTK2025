extends Node
# Global Event bus

var ruined_day_speed_multiplier := 0.8
var is_day_ruined := false

signal rotate_world(angle_delta: float)
signal day_ruined()
signal day_reset()
