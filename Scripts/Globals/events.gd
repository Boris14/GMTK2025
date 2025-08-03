extends Node
# Global Event bus

var is_day_ruined := false
var is_first_sleep := true

signal rotate_world(angle_delta: float)
signal day_ruined()
signal day_reset()
signal win()
