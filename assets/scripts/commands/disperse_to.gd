class_name DisperseState extends State

const BASE_DISPERSION_RADIUS := 50  # Raio base para cálculo
const MAX_RADIUS_SCALING := 2  # Fator de escala para o número de tropas

var selected_troops: Array = []  # Store selected troops
var used_positions: Array = []  # Track positions that are already used
var dispersion_radius: float = BASE_DISPERSION_RADIUS  # Raio ajustável

func prepare() -> void:
	pass

func enter(_previous_state: State, args) -> void:
	# Expect the argument to be an array of selected troops
	if args is Array:
		selected_troops = args
		used_positions = []
		
		# Adjust the dispersion radius based on the number of troops
		dispersion_radius = BASE_DISPERSION_RADIUS + (MAX_RADIUS_SCALING * selected_troops.size())
	
	# Generate random positions for each selected troop
	for troop in selected_troops:
		# Check if the troop is still valid
		if not is_instance_valid(troop):
			continue

		var valid_position := false
		var target_pos: Vector2

		while not valid_position:
			# Generate a random offset and calculate the target position
			var random_offset = Vector2(
				randf_range(-dispersion_radius, dispersion_radius),
				randf_range(-dispersion_radius, dispersion_radius)
			)
			target_pos = troop.global_position + random_offset
			valid_position = true

			# Verify if the target position is far enough from other used positions
			for pos in used_positions:
				if pos.distance_to(target_pos) < troop.disperse_aprox_distance:
					valid_position = false
					break

		# Assign the target position to the troop using NavigationAgent2D
		troop.disperse_to(target_pos)
		used_positions.append(target_pos)

	leave_command()


func leave_command() -> void:
	state_machine.transition(self, "no_command")

func exit(_next_state: State) -> void:
	pass
