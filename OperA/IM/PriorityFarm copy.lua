-- If OperA is a local enforcer, should each bot have their own structure for such scenes? 
-- Or rather should norms indicate the role in question?


local x = [[{
	"norms": [
		{
            "name" : "farm",
            "behaviour" : "DE-FarmLane",
            "operator" : "1"
        },
        {
            "name" : "harass",
            "behaviour" : "DE-Harass",
            "operator" : "0"
		}
	],
	"scenes": [
		{
            "name" : "priorityFarm",
            "roles" : [],
            "landmarks" : [
                {
                    "name": "AllyHeroNearby",
                    "value": "1",
                    "comparator": "bool"
                },
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
                    "name": "AllyHeroNearby",
                    "value": "0",
                    "comparator": "bool"
                }
            ],
            "norms" : [
                {
                    "name" : "harass"
                }
            ],
            "rules" : [
                {
                    "name" : "hasHighestPriorityAround",
                    "value": "0",
                    "comparator": "bool"
                }
            ]
        }
	]
}]]

return x