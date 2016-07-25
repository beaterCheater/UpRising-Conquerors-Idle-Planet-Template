#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;It is recommended to have upgraded the first planet at least 1 in each building to start a ship.

p::
	main()
	return
o::
	ExitApp

t::	
	overviewMain()
	return
	
g::
	overview := new Overview()
	overview.startGui()
	return


;Global settings
MOUSE_CLICK_DELAY := 100

;Used for planet template
POWER_PLANT_LVL := 45
MATERIAL_EXTRACTOR_LVL := 40
WAREHOUSE_LVL := 20
FUEL_GEN_LVL := 35
FUEL_TANK_LVL := 20
HANGAR_LVL := 3
SHIP_LVL := 21

;Max planets 29
PLANETS_TO_UPGRADE := 29

;When to buy research and upgrades
RESEARCH_UPGRADE_INTERVAL := 3
PLANET_COUNT_TO_BUY_UPGRADES_1 := 5

	
test() {
	;Test function used for simple testing of sections of code.
	research := new Research()
	research.upgrade()
}

overviewMain() {
	overview := new Overview()
	overview.upgradeLoop()
}

main() {
	planetTemplate := new PlanetTemplate(POWER_PLANT_LVL,40,20,35,20,3,21)
	allPlanetsComplete := false
	listOfPlanets := Array()
	planetCount := 20
	currentPlanetCount := 1
	research := new Research()
	boughtUpgradesPartOne := false
	planetCountToBuyUpgradesPartOne := 5
	researchUpgradeInterval := 3
	researchTimeCount := 1
	
	Loop %planetCount% {
		listOfPlanets.Push(new Planet(planetTemplate))
	}
	
	while (allPlanetsComplete = false) {
		currentPlanetCursor := 1
		allPlanetsComplete := true
		
		for index, planet in listOfPlanets {
			if (boughtUpgradesPartOne = false) and (currentPlanetCount = planetCountToBuyUpgradesPartOne) {
				boughtUpgradesPartOne := true
				navigateToResearch()
				buyUpgradesPartOne()
			}
			
		
			planet.upgrade()
			if (planet.isFullyUpgraded() = false) {
				allPlanetsComplete := false
			}
			navigateToNextPlanet()
			
			
			if (sendShip() = true) {
				navigateToFirstPlanet(currentPlanetCursor)
				currentPlanetCount := currentPlanetCount + 1
				break
			}
			
			; Check for end of planet limit or havent bought enough planets.
			if (currentPlanetCursor = planetCount) or (currentPlanetCount = currentPlanetCursor){
				navigateToFirstPlanet(currentPlanetCursor)
				break
			}
			currentPlanetCursor := currentPlanetCursor + 1
		}
		
		if (boughtUpgradesPartOne = false) and (currentPlanetCount = planetCountToBuyUpgradesPartOne) {
			boughtUpgradesPartOne := true
			navigateToUpgrades()
			buyUpgradesPartOne()
			backToGalaxy()
		}
		if (researchTimeCount = researchUpgradeInterval) {
			navigateToResearch()
			research.upgrade()
			backToGalaxy()
			researchTimeCount := 0
		}
		researchTimeCount := researchTimeCount + 1
	}
}


Class Overview {

	__New() {
		this.planetsToUpgrade := PLANETS_TO_UPGRADE
		this.planetTemplate := new PlanetTemplate(POWER_PLANT_LVL, MATERIAL_EXTRACTOR_LVL, WAREHOUSE_LVL, FUEL_GEN_LVL, FUEL_TANK_LVL, HANGAR_LVL, SHIP_LVL)
		this.research := new Research()
		this.listOfPlanets := Array()
		this.setUpListOfPlanets()
	}
	
	setUpListOfPlanets() {
		loopIterations := this.planetsToUpgrade
		Loop %loopIterations% {
			this.listOfPlanets.Push(new Planet(this.planetTemplate))
		}
	}
	
	upgradeLoop() {
		allPlanetsComplete := false
		currentPlanetCount := 1
		boughtUpgradesPartOne := false
		planetCountToBuyUpgradesPartOne := 5
		researchUpgradeInterval := 3
		researchTimeCount := 1
		
		while (allPlanetsComplete = false) {
			allPlanetsComplete = true
			currentPlanetCursor := 1
		
			for index, planet in this.listOfPlanets {
				if (planet.isFullyUpgraded()) {
					navigateToNextPlanet()
					continue
				} else {
					allPlanetsComplete := false
				}
				planet.upgrade()
				navigateToNextPlanet()
				
				if sendShip() {
					navigateToFirstPlanet(currentPlanetCursor)
					currentPlanetCount := currentPlanetCount + 1
					break
				}
				
				; Check for end of planet limit or havent bought enough planets.
				if (currentPlanetCursor = planetCount) or (currentPlanetCount = currentPlanetCursor){
					navigateToFirstPlanet(currentPlanetCursor)
					break
				}
				currentPlanetCursor := currentPlanetCursor + 1
			}
			
			if (boughtUpgradesPartOne = false) and (currentPlanetCount = planetCountToBuyUpgradesPartOne) {
				boughtUpgradesPartOne := true
				navigateToUpgrades()
				buyUpgradesPartOne()
				backToGalaxy()
			}
			if (researchTimeCount = researchUpgradeInterval) {
				navigateToResearch()
				research.upgrade()
				backToGalaxy()
				researchTimeCount := 0
			}
			researchTimeCount := researchTimeCount + 1
		}	
	}
}

navigateToResearch() {
	x := 620
	y := 377
	MouseClick, left, x, y
	Sleep, 400
}

navigateToUpgrades() {
	x := 537
	y := 369
	MouseClick, left, x, y
	Sleep, 300
}

buyUpgradesPartOne() {
	x := 1125
	y := [486, 561, 637, 718, 790, 870]
	for index, ycoord in y {
		MouseClick, left, x, ycoord
		Sleep,200
	}
}

navigateToFirstPlanet(jumpsBack) {
	Loop %jumpsBack% {
		Send {a}
		Sleep, 300
	}
}

navigateToNextPlanet() {
	Send {d}
	Sleep, 200
}

sendShip() {
	x := 1229
	y := 518
	variations := 80
	sentShip := false
	ImageSearch, coordX, coordY, 1114, 484, 1266, 532, *%variations% fig/sendShip.png
	if (ErrorLevel = 0) {
		MouseClick, left, x, y
		sentShip := true
		Sleep, 300
		;MsgBox, Found image.
	} else if (ErrorLevel = 1) {
		;MsgBox Image not found
	} else if (ErrorLevel = 2) {
		;MsgBox Loading error
	}
	return sentShip
}

cannotSendShip() {
	variations := 220
	ImageSearch, coordX, coordY, 1110, 484, 1280, 532, *%variations% fig/cannotSendShip.png
	if (ErrorLevel = 0) {
		MsgBox, Found image.
	} else if (ErrorLevel = 1) {
		MsgBox Image not found
	} else if (ErrorLevel = 2) {
		MsgBox Loading error
	}
}

backToGalaxy() {
	x := 1074
	y := 380
	MouseClick, left, x, y
	Sleep, 400
}

Class Research{

	__New() {
		this.radiantLvl := 1
		this.ionicLvl := 1
		this.combustionLvl := 1
		this.picobotsLvl := 1
		this.atmosphericLvl := 1
		this.cosmicLvl := 1
		this.researchAvailableColor := "0xBDB97D"
	}
	
	upgrade() {
		this.upgradeCosmic()
		Sleep, 200
		this.upgradeRadiant()
		Sleep, 200
		this.upgradeCombustion()
		Sleep, 200
		this.upgradeIonic()
		Sleep, 200
		this.upgradePicobots()
		Sleep, 200
		this.upgradeAtmospheric()
		Sleep, 200
	}
	
	upgradeCosmic() {
		x := 1121
		y := 861
		variation := 60
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.cosmicLvl := this.cosmicLvl + 1
			;MsgBox, Cosmic Found.
		} else {
			;MsgBox, Cosmic not found.
		}
	}
	
	upgradeRadiant() {
		x := 791
		y := 557
		variation := 50
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.radiantLvl := this.radiantLvl + 1
			;MsgBox, Radiant found.
		} else {
			;MsgBox, Radiant not found
		}
	}
	
	upgradeCombustion() {
		x := 794
		y := 710
		variation := 50
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.combustionLvl := this.combustionLvl + 1
			;MsgBox, Combustion Found
		} else {
			;MsgBox, Combustion not found.
		}
	}
	
	upgradeIonic() {
		x := 1121
		y := 562
		variation := 60
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.ionicLvl := this.ionicLvl + 1
			;MsgBox, Ionic found.
		} else {
			;MsgBox, Ionic found
		}
	}
	
	upgradePicobots() {
		x := 1121
		y := 710
		variation := 60
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.picobotsLvl := this.picobotsLvl + 1
			;MsgBox, Picobots found.
		} else {
			;MsgBox, Picobots not found.
		}
	}
	
	upgradeAtmospheric() {
		x := 794
		y := 863
		variation := 60
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			this.atmosphericLvl := this.atmosphericLvl + 1
			;MsgBox, Atmospheric found.
		} else {
			;MsgBox, Atmospheric not found.
		}
	}
}

Class PlanetTemplate{

	__New(powerPlantLvl, materialExtractorLvl, warehouseLvl, fuelGenLvl, fuelTankLvl, hangarLvl, shipLvl){
		this.powerPlantLvl := powerPlantLvl
		this.materialExtractorLvl := materialExtractorLvl
		this.warehouseLvl := warehouseLvl
		this.fuelGenLvl := fuelGenLvl
		this.fuelTankLvl := fuelTankLvl
		this.hangarLvl := hangarLvl
		this.shipLvl := shipLvl
	}
}

Class Planet{
	
	__New(planetTemplate){
	this.powerPlantLvl := 0
	this.materialExtractorLvl := 0
	this.warehouseLvl := 0
	this.fuelGenLvl := 0
	this.fuelTankLvl := 0
	this.hangarLvl := 0
	this.planetTemplate := planetTemplate
	this.upgradeAvailableColor := "0xFFFFFF"
	this.listOfShips := Array()
	}
	
	upgrade() {
		Sleep, 200
		this.upgradePowerPlant()
		Sleep, 400
		this.upgradeHanger()
		Sleep, 400
		this.upgradeMaterialExtractor()
		Sleep, 400
		this.upgradeFuelGen()
		Sleep, 400
		this.upgradeWareHouse()
		Sleep, 400
		this.upgradeFuelTank()
		Sleep, 400
		this.upgradeShips()
		Sleep, 400
	}
	
	upgradePowerPlant() {
		if (this.powerPlantLvl < this.planetTemplate.powerPlantLvl) {
			x := 1187
			y := 484
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				this.powerPlantLvl := this.powerPlantLvl + 1
			}
		}
	}
	
	upgradeMaterialExtractor() {
		if (this.materialExtractorLvl < this.planetTemplate.materialExtractorLvl) {
			x := 1189
			y := 543
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				this.materialExtractorLvl := this.materialExtractorLvl + 1
			}
		}
	}
	
	upgradeWareHouse() {
		if (this.warehouseLvl < this.planetTemplate.warehouseLvl) {
			x := 1189
			y := 606
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				this.warehouseLvl := this.warehouseLvl + 1
			}
		}
	}
	
	upgradeFuelGen() {
		if (this.fuelGenLvl < this.planetTemplate.fuelGenLvl) {
			x := 1195
			y := 661
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				this.fuelGenLvl := this.fuelGenLvl + 1
			}
		}
	}
	
	upgradeFuelTank() {
		if (this.fuelTankLvl < this.planetTemplate.fuelTankLvl) {
			x := 1195
			y := 716
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				this.fuelTankLvl := this.fuelTankLvl + 1
			}
		}
	}
	
	upgradeHanger() {
		if (this.hangarLvl < this.planetTemplate.hangarLvl) {
			x := 1262
			y := 786
			x2 := 1195
			y2 := 781
			variation := 13
			if (pixelSearch(x, y, this.upgradeAvailableColor, variation)) and  (pixelSearch(x2, y2, this.upgradeAvailableColor, variation)){
				MouseClick, left, x, y
				this.hangarLvl := this.hangarLvl + 1
				this.listOfShips.Push(new Ship(this.planetTemplate.shipLvl, this.hangarLvl))
				ToolTip, Hangar found, 0, 0
			} else {
				ToolTip, Hangar not found, 0, 0
			}
		}
	}
	
	upgradeShips() {
		;MsgBox, upgrade ships.
		for index, ship in this.listOfShips {
			ship.upgradeShip()
			Sleep, 400
		}
	}
	
	isFullyUpgraded() {
		return (this.planetTemplate.powerPlantLvl = this.powerPlantLvl) and (this.planetTemplate.materialExtractorLvl = this.materialExtractorLvl) and (this.planetTemplate.warehouseLvl = this.warehouseLvl) and (this.planetTemplate.fuelGenLvl = this.fuelGenLvl) and (this.planetTemplate.fuelTankLvl = this.fuelTankLvl) and (this.planetTemplate.hangarLvl = this.hangarLvl) and this.areAllShipsUpgraded()
	}
	
	areAllShipsUpgraded() {
		for ship in listOfShips {
			if not ship.isShipFullyUpgraded() {
				return false
			}
		}
		return true
	}
}

Class Ship{

	__New(desiredShipLvl, shipNumber){
		this.shipLvl := 1
		this.desiredShipLvl := desiredShipLvl
		this.shipNumber := shipNumber
		this.upgradeShipAvailableColor := "0xEBE0CD"
	}
	
	isShipFullyUpgraded() {
		return (this.shipLvl = this.desiredShipLvl)
	}
	
	upgradeShip() {
		if (this.shipLvl < this.desiredShipLvl) {
			x := 1206
			y := this.getYCoordBasedOnShipNr()
			variation := 50
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeShipAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.shipLvl := this.shipLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, Ship upgrade not found, %y%
			}
		}
	}
	
	getYCoordBasedOnShipNr() {
		if (this.shipNumber = 1) {
			return 811
		} else if (this.shipNumber = 2) {
			return 843
		} else if (this.shipNumber = 3) {
			return 876
		}
	}
}

pixelSearch(xCenter, yCenter, colorToFind, variation) {
	PixelSearch, Px, Py, xCenter-2, yCenter-2, xCenter+2, yCenter+2, colorToFind, variation, Fast
	if not ErrorLevel {
		return true
	} else {
		return false
	}
}

