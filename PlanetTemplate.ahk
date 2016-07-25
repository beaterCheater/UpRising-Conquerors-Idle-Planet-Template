#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;It is recommended to have upgraded the first planet at least 1 in each building to start a ship.


;Global settings
global MOUSE_CLICK_DELAY := 100
global KEYBOARD_A_CLICK := 100
global KEYBOARD_D_CLICK := 100

;Used for planet template
global POWER_PLANT_LVL := 45
global MATERIAL_EXTRACTOR_LVL := 40
global WAREHOUSE_LVL := 20
global FUEL_GEN_LVL := 35
global FUEL_TANK_LVL := 20
global HANGAR_LVL := 3
global SHIP_LVL := 21

;Max planets 29
global PLANETS_TO_UPGRADE := 29

;When to buy research and upgrades
global RESEARCH_UPGRADE_INTERVAL := 3
global PLANET_COUNT_TO_BUY_UPGRADES_1 := 5

test() {
	;Test function used for simple testing of sections of code.
	upg := new Upgrades()
	upg.clickToSecondPage()
}

overviewMain() {
	overview := new Overview()
	overview.upgradeLoop()
}

Class Overview {

	__New() {
		this.planetTemplate := new PlanetTemplate(POWER_PLANT_LVL, MATERIAL_EXTRACTOR_LVL, WAREHOUSE_LVL, FUEL_GEN_LVL, FUEL_TANK_LVL, HANGAR_LVL, SHIP_LVL)
		this.research := new Research()
		this.upgrades := new Upgrades()
		this.listOfPlanets := Array()
		this.setUpListOfPlanets()
	}
	
	setUpListOfPlanets() {
		Loop %PLANETS_TO_UPGRADE% {
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
		
		this.initFirstPlanet()
		while (allPlanetsComplete = false) {
			allPlanetsComplete = true
			currentPlanetCursor := 1
			v := this.listOfPlanets.Length()
			
			for index, planet in this.listOfPlanets {
				if (planet.isFullyUpgraded()) {
					navigateToNextPlanet()
					currentPlanetCursor := currentPlanetCursor + 1
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
				;buyUpgradesPartOne()
				upgrades.upgrade()
				backToGalaxy()
			}
			if (researchTimeCount = researchUpgradeInterval) {
				navigateToResearch()
				this.research.upgrade()
				backToGalaxy()
				researchTimeCount := 0
			}
			researchTimeCount := researchTimeCount + 1
		}	
	}
	
	initFirstPlanet() {
		;Setting up the first planet.
		this.listOfPlanets[1].initPlanet()
	}
}

navigateToResearch() {
	x := 620
	y := 377
	MouseClick, left, x, y
	Sleep, MOUSE_CLICK_DELAY
}

navigateToUpgrades() {
	x := 537
	y := 369
	MouseClick, left, x, y
	Sleep, MOUSE_CLICK_DELAY
}

buyUpgradesPartOne() {
	x := 1125
	y := [486, 561, 637, 718, 790, 870]
	for index, ycoord in y {
		MouseClick, left, x, ycoord
		Sleep, MOUSE_CLICK_DELAY
	}
}

navigateToFirstPlanet(jumpsBack) {
	Loop %jumpsBack% {
		Send {a}
		Sleep, KEYBOARD_A_CLICK
	}
}

navigateToNextPlanet() {
	Send {d}
	Sleep, KEYBOARD_D_CLICK
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
		Sleep, MOUSE_CLICK_DELAY
		;MsgBox, Found image.
	} else if (ErrorLevel = 1) {
		;MsgBox Image not found
	} else if (ErrorLevel = 2) {
		;MsgBox Loading error
	}
	return sentShip
}

cannotSendShip() {
	;Currently not used
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
	Sleep, MOUSE_CLICK_DELAY
}

class Upgrades {

	__New() {
		this.upgradeAvailableColor := "0x009600"
		this.xCoordAvailable := 807
		this.yCoordAvailableFirstPage := [481, 555, 633, 709, 785, 861]
		this.yCoordAvailableSecondPage := [614, 687, 765, 840]
		this.yCoordAvailableThirdPage := [594, 670, 745, 821]
		this.yCoordAvailableFourthPage := [487, 564, 639, 716, 791, 868]
		this.xCoordToClick := 1129
		this.variation := 10
	}
	
	upgrade() {
		this.upgradePage(this.yCoordAvailableFirstPage)
		this.clickToSecondPage()
		this.upgradePage(this.yCoordAvailableSecondPage)
		this.clickToThirdPage()
		this.upgradePage(this.yCoordAvailableThirdPage)
		this.clickToFourthPage()
		this.upgradePage(this.yCoordAvailableFourthPage)
	}
	
	upgradePage(pageNumberList) {
		for index, y in pageNumberList {
			if (pixelSearch(this.xCoordAvailable, y, this.upgradeAvailableColor, this.variation) {
				MouseClick, Left, this.xCoordToClick, y
				Sleep, MOUSE_CLICK_DELAY
			}
		}
	}
	
	clickToSecondPage() {
		xCoord := 1233
		yCoord := 635
		MouseClick, Left, xCoord, yCoord
		Sleep, MOUSE_CLICK_DELAY
	}
	
	clickToThirdPage() {
		xCoord := 1233
		yCoord := 732
		MouseClick, Left, xCoord, yCoord
		Sleep, MOUSE_CLICK_DELAY
	}
	
	clickToFourthPage() {
		xCoord := 1233
		yCoord := 900
		MouseClick, Left, xCoord, yCoord
		Sleep, MOUSE_CLICK_DELAY
	}
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
		this.upgradeRadiant()
		this.upgradeCombustion()
		this.upgradeIonic()
		this.upgradePicobots()
		this.upgradeAtmospheric()
	}
	
	upgradeCosmic() {
		x := 1121
		y := 861
		variation := 60
		PixelSearch, Px, Py, x-5, y-5, x+5, y+5, this.researchAvailableColor, variation, Fast
		if not ErrorLevel {
			MouseClick, left, x, y
			Sleep, MOUSE_CLICK_DELAY
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
			Sleep, MOUSE_CLICK_DELAY
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
			Sleep, MOUSE_CLICK_DELAY
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
			Sleep, MOUSE_CLICK_DELAY
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
			Sleep, MOUSE_CLICK_DELAY
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
			Sleep, MOUSE_CLICK_DELAY
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
	
	initPlanet() {
		;If this planet is the first one. This function must be run.
		this.upgradePowerPlant()
		this.upgradePowerPlant()
		this.upgradeMaterialExtractor()
		this.upgradeWareHouse()
		this.upgradeFuelGen()
		this.upgradeFuelTank()
		this.upgradeHanger()
	}
	
	upgrade() {
		Sleep, 200
		this.upgradePowerPlant()
		this.upgradeHanger()
		this.upgradeMaterialExtractor()
		this.upgradeFuelGen()
		this.upgradeWareHouse()
		this.upgradeFuelTank()
		this.upgradeShips()
	}
	
	upgradePowerPlant() {
		if (this.powerPlantLvl < this.planetTemplate.powerPlantLvl) {
			x := 1187
			y := 484
			variation := 5
			if pixelSearch(x, y, this.upgradeAvailableColor, variation) {
				MouseClick, left, x, y
				Sleep, MOUSE_CLICK_DELAY
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
				Sleep, MOUSE_CLICK_DELAY
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
				Sleep, MOUSE_CLICK_DELAY
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
				Sleep, MOUSE_CLICK_DELAY
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
				Sleep, MOUSE_CLICK_DELAY
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
			x3 := 1238
			y3 := 761
			variation := 13
			if (pixelSearch(x, y, this.upgradeAvailableColor, variation)) and  (pixelSearch(x2, y2, this.upgradeAvailableColor, variation)) (pixelSearch(x3, y3, this.upgradeAvailableColor, variation)) {
				MouseClick, left, x, y
				Sleep, MOUSE_CLICK_DELAY
				this.hangarLvl := this.hangarLvl + 1
				this.listOfShips.Push(new Ship(this.planetTemplate.shipLvl, this.hangarLvl))
				;ToolTip, Hangar found, 0, 0
			} else {
				;ToolTip, Hangar not found, 0, 0
			}
		}
	}
	
	upgradeShips() {
		;MsgBox, upgrade ships.
		for index, ship in this.listOfShips {
			ship.upgradeShip()
		}
	}
	
	isFullyUpgraded() {
		return (this.planetTemplate.powerPlantLvl = this.powerPlantLvl) and (this.planetTemplate.materialExtractorLvl = this.materialExtractorLvl) and (this.planetTemplate.warehouseLvl = this.warehouseLvl) and (this.planetTemplate.fuelGenLvl = this.fuelGenLvl) and (this.planetTemplate.fuelTankLvl = this.fuelTankLvl) and (this.planetTemplate.hangarLvl = this.hangarLvl) and this.areAllShipsUpgraded()
	}
	
	areAllShipsUpgraded() {
		for index, ship in this.listOfShips {
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
				Sleep, MOUSE_CLICK_DELAY
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

p::
	overviewMain()
	return
o::
	ExitApp
	
t::	
	test()
	return
