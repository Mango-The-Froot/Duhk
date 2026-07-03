extends Node

var playerBody: CharacterBody2D
var playerDamage: int
var playerDamageZone: Area2D
var playerHealth
var playerHitbox: Area2D
var playerDeaths

var bossRatDmgZone: Area2D
var bossRatDmg: int

var ratDamageZone: Area2D
var ratDamage: int

var nextZone: Marker2D
var lastZone: Marker2D

var money: int = 0
