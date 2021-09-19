local x = [[{
	"norms": [
		{
                  "name" : "farm",
                  "behaviour" : "DE-FarmLane",
                  "operator" : "PERMITTED"
            },
            {
                  "name" : "heal",
                  "behaviour" : "DE-HealAlly",
                  "operator" : "OBLIGED"
		}
	],
	"scenes": [
		{
                  "name" : "farmingTime",
                  "roles" : [],
                  "landmarks" : [],
                  "results" : [],
                  "norms" : [
                        {
                              "name" : "farm"
                        }
                  ]
		}
	]
}]]

return x