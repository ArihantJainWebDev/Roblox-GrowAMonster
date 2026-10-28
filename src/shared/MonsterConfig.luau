-- Shared display and balance values. The server remains authoritative.
return {
	MaxXP = 100,
	GrowthStages = {
		{ Id = "Baby", Name = "Baby Sprout", AtXP = 0, Scale = 1 },
		{ Id = "Young", Name = "Young Sprout", AtXP = 100, Scale = 1.25 },
	},
}
