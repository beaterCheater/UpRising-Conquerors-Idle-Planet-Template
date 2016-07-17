﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

p::
	main()
	return
o::
	ExitApp

t::	
	sendShip()
	return
	
test() {
	research := new Research()
	research.upgrade()
}

main() {
	planetTemplate := new PlanetTemplate(45,40,20,35,20,3,21)
	allPlanetsComplete := false
	listOfPlanets := Array()
	planetCount := 20
	research := new Research()
	
	Loop %planetCount% {
		listOfPlanets.Push(new Planet(planetTemplate))
	}
	
	while (allPlanetsComplete = false) {
		currentPlanetCursor := 1
		allPlanetsComplete := true
		
		for index, planet in listOfPlanets {
			planet.upgrade()
			if (planet.isFullyUpgraded() = false) {
				allPlanetsComplete := false
			}
			navigateToNextPlanet()
			sendShip()	
			if (currentPlanetCursor = planetCount) {
				navigateToFirstPlanet(planetCount)
				currentPlanetCursor := 1
			}
			currentPlanetCursor := currentPlanetCursor + 1
		}
		navigateToResearch()
		research.upgrade()
		updateUpgrades()
		backToGalaxy()
	}
}

navigateToResearch() {
	x := 620
	y := 377
	MouseClick, left, x, y
	Sleep, 400
}

updateUpgrades() {
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
	ImageSearch, coordX, coordY, 1114, 484, 1266, 532, *%variations% fig/sendShip.png
	if (ErrorLevel = 0) {
		MouseClick, left, x, y
		Sleep, 300
		;MsgBox, Found image.
	} else if (ErrorLevel = 1) {
		;MsgBox Image not found
	} else if (ErrorLevel = 2) {
		;MsgBox Loading error
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
		Sleep, 500
		this.upgradeHanger()
		Sleep, 500
		this.upgradeMaterialExtractor()
		Sleep, 500
		this.upgradeFuelGen()
		Sleep, 500
		this.upgradeWareHouse()
		Sleep, 500
		this.upgradeFuelTank()
		Sleep, 500
		this.upgradeShips()
		Sleep, 400
	}
	
	upgradePowerPlant() {
		if (this.powerPlantLvl < this.planetTemplate.powerPlantLvl) {
			x := 1187
			y := 484
			variation := 5
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.powerPlantLvl := this.powerPlantLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, Powerplant not found
			}
		}
	}
	
	upgradeMaterialExtractor() {
		if (this.materialExtractorLvl < this.planetTemplate.materialExtractorLvl) {
			x := 1189
			y := 543
			variation := 5
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.materialExtractorLvl := this.materialExtractorLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeWareHouse() {
		if (this.warehouseLvl < this.planetTemplate.warehouseLvl) {
			x := 1189
			y := 606
			variation := 5
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.warehouseLvl := this.warehouseLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeFuelGen() {
		if (this.fuelGenLvl < this.planetTemplate.fuelGenLvl) {
			x := 1195
			y := 661
			variation := 5
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.fuelGenLvl := this.fuelGenLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeFuelTank() {
		if (this.fuelTankLvl < this.planetTemplate.fuelTankLvl) {
			x := 1195
			y := 716
			variation := 5
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.fuelTankLvl := this.fuelTankLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeHanger() {
		if (this.hangarLvl < this.planetTemplate.hangarLvl) {
			x := 1195
			y := 777
			variation := 10
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.hangarLvl := this.hangarLvl + 1
				this.listOfShips.Push(new Ship(this.planetTemplate.shipLvl, this.hangarLvl))
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeShips() {
		;MsgBox, upgrade ships.
		for index, ship in this.listOfShips {
			ship.upgradeShip()
			Sleep, 500
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

