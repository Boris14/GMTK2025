extends Node
# Global Event bus

static var is_day_ruined := false
static var is_first_sleep := true

signal rotate_world(angle_delta: float)
signal day_ruined()
signal day_reset()
signal win()
