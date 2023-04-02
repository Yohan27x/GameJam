extends Node


func instanceSceneOnMain(scene, position):
	
	var main = get_tree().current_scene
	var instance = scene.instance()
	instance.global_position = position

	main.call_deferred("add_child", instance)

	return instance

func instanceSceneOnNode(mother_node, scene, position):
	var instance = scene.instance()
	
	instance.global_position = position
	
	mother_node.call_deferred("add_child", instance)
	
	# ajouter l'item au ysort du level ou au node qui vient de call cette fonction
	return instance
