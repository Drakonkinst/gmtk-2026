extends Panel

@onready var rank := %Rank as Label
@onready var score := %Score as Label
@onready var user_name := %Name as Label

func constructor(params):
	rank.text = '%d' % [params['rank']]
	score.text = '%d' % [params['score']]
	user_name.text = params['name']
