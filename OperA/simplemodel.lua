local x = [[{
	"norms": [
		{
                  "name" : "farm",
                  "behaviour" : "DE-FarmLane",
                  "operator" : "PERMITTED"
            },
            {
                  "name" : "support",
                  "behaviour" : "DE-Support",
                  "operator" : "OBLIGED"
		}
	],
	"scenes": [
		{
                  "name" : "farmingTime",
                  "roles" : [ "1", "2" ],
                  "landmarks" : [
				{
					"name": "IsFarmingTime",
					"value": "1",
					"comparator": "bool"
				},
				{
					"name": "PartnerNearby",
					"value": "1",
					"comparator": "bool"
				}
			],
                  "results" : [
				{
					"name": "PartnerNearby",
					"value": "0",
					"comparator": "bool"
				}
                  ],
                  "norms" : [
                        {
                            "name" : "support",
							"role" : "2"
                        },
						{
							"name" : "farm",
							"role" : "1"
						}
                  ]
		}
	]
}]]

return x