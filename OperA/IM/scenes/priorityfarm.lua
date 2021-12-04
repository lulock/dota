-- priority farming scene for pos 5 role.
-- TODO: add new variable "Rules". IF THEN conditions. Norm is only a bool indicating the expected behaviour (Drive)
local x = [[{
	"norms": [
		{
			"name" : "farm",
			"behaviour" : "DE-FarmLane",
			"operator" : "PERMITTED"
		},
		{
			"name" : "harass",
			"behaviour" : "DE-Harass",
			"operator" : "OBLIGED"
		}
	],
	"scenes": [
		{
			"name" : "priorityFarm",
			"roles" : [],
			"landmarks" : [
                {
                    "name": "AllyNearby",
                    "value": "1",
                    "comparator": "bool",
                }
				{
					"name": "IsFarmingTime",
					"value": "1",
					"comparator": "bool"
				},
				{
					"name": "IsSafeToFarm",
					"value": "1",
					"comparator": "bool"
				}
			],
            "results" : [
				{
					"name": "AllyNearby",
					"value": "0",
					"comparator": "bool"
				}
            ],
            "rules" : [
                {
                    "conditions" : [
                        {
                            "name" : "HasHighestPriorityAround",
                            "value" : "1",
                            "comparator" : "bool"
                        }
                    ], 
                    "norm" : "farm"
                },
                {
                    "conditions" : [
                        {
                            "name" : "HasHighestPriorityAround",
                            "value" : "0",
                            "comparator" : "bool"
                        }
                    ], 
                    "norm" : "harass"
                }
            ]
		}
	]
}]]

return x