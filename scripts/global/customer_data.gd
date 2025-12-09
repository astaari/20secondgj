extends Node

var customers : Dictionary[int,Customer]= {
	0 : preload("res://resources/customers/girl.tres"),
	1 : preload("res://resources/customers/old_lady.tres")
}

#not final. Just examples
var available_tags : Array[String]= [
	"stripes",
	"dress",
	"purple",
	"lipstick"
]

func get_random() -> Customer:
	var maplen : int = len(customers)
	return customers[randi_range(0,maplen-1)]
