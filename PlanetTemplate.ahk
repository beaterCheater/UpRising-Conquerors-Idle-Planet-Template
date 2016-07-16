#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

p::
	main()
	return
o::
	ExitApp

t::	
	test()
	return
	
test() {
	;MsgBox, Test2
	ship1 := new Ship(3,2)
	ship1.upgradeShip()
}

main() {
	planetTemplate := new PlanetTemplate(10,10,10,10,10,1)
	allPlanetsComplete := false
	listOfPlanets := Array()
	listOfPlanets.Push(new Planet(planetTemplate))
	planetCount := 1
	
	while (allPlanetsComplete = false) {
		updateResearch()
		updateUpgrades()
		currentPlanetCursor := 1
		allPlanetsComplete := true
		
		for planet in listOfPlanets {
			planet.upgrade()
			if (planet.isFullyUpgraded() = false) {
				allPlanetsComplete := false
			}
			if (currentPlanetCursor = planetCount) {
				navigateToFirstPlanet(planetCount-1)
				currentPlanetCursor := 1
			} else {
				navigateToNextPlanet()
				sendShip()
				currentPlanetCursor := currentPlanetCursor + 1
			}
		}
		
	}
}

updateResearch() {
}

updateUpgrades() {
}

navigateToFirstPlanet(jumpsBack) {
	Loop %jumpsBack% {
		Send {a}
		Sleep, 100
	}
}

navigateToNextPlanet() {
	Send {d}
	Sleep, 200
}

sendShip() {
}

Class Research{

	__New() {
		this.radiantLvl := 1
		this.ionicLvl := 1
		this.combustionLvl := 1
		this.picobotsLvl := 1
		this.atmosphericLvl := 1
		this.cosmicLvl := 1
	}
}

Class PlanetTemplate{

	__New(powerPlantLvl, materialExtractorLvl, warehouseLvl, fuelGenLvl, fuelTankLvl, hangarLvl, numShips, shipsLvl){
		this.powerPlantLvl := powerPlantLvl
		this.materialExtractorLvl := materialExtractorLvl
		this.warehouseLvl := warehouseLvl
		this.fuelGenLvl := fuelGenLvl
		this.fuelTankLvl := fuelTankLvl
		this.hangarLvl := hangarLvl
		this.numShips := numShips
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
		this.upgradePowerPlant()
		Sleep, 500
		this.upgradeMaterialExtractor()
		Sleep, 500
		this.upgradeWareHouse()
		Sleep, 500
		this.upgradeFuelGen()
		Sleep, 500
		this.upgradeFuelTank()
		Sleep, 500
		this.upgradeHanger()
		Sleep, 500
		this.upgradeShips()
		Sleep, 500
	}
	
	upgradePowerPlant() {
		if (this.powerPlantLvl < this.planetTemplate.powerPlantLvl) {
			x := 1187
			y := 484
			variation := 0
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.powerPlantLvl := this.powerPlantLvl + 1
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeMaterialExtractor() {
		if (this.materialExtractorLvl < this.planetTemplate.materialExtractorLvl) {
			x := 1189
			y := 543
			variation := 0
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
			variation := 0
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
			variation := 0
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
			variation := 0
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
			y := 716
			variation := 0
			PixelSearch, Px, Py, x-2, y-2, x+2, y+2, this.upgradeAvailableColor, variation, Fast
			if not ErrorLevel {
				MouseClick, left, x, y
				this.hangarLvl := this.hangarLvl + 1
				this.listOfShips.Push(new Ship(this.planetTemplate.shipLvl))
				;MsgBox, Found.
			} else {
				;MsgBox, That color was not found in the specified region.
			}
		}
	}
	
	upgradeShips() {
		for ship in listOfShips {
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
				MsgBox, Ship upgrade not found, %y%
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

