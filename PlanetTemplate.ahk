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
	planetTemplate := new PlanetTemplate(10,10,10,10,10,1)
	myPlanet := new Planet(planetTemplate)
	myPlanet.upgradeFuelGen()
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
		Loop %planetCount% {
			currentPlanet = listOfPlanets[currentPlanet]
			currentPlanet.upgrade()
			if (currentPlanet.isFullyUpgraded() = false) {
				allPlanetsComplete := false
			}
			if (currentPlanetCursor = planetCount) {
				navigateToFirstPlanet()
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

navigateToFirstPlanet() {
}

navigateToNextPlanet() {
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
	this.PlanetTemplate := planetTemplate
	this.upgradeAvailableColor := "0xFFFFFF"
	this.listOfShips := Array()
	}
	
	upgrade() {
		this.upgradePowerPlant()
		this.upgradeMaterialExtractor()
		this.upgradeWareHouse()
		this.upgradeFuelGen()
		this.upgradeFuelTank()
		this.upgradeHanger()
	}
	
	upgradePowerPlant() {
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
	
	upgradeMaterialExtractor() {
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
	
	upgradeWareHouse() {
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
	
	upgradeFuelGen() {
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
	
	upgradeFuelTank() {
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
	
	upgradeHanger() {
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
	
	isFullyUpgraded() {
		return (this.planetTemplate.powerPlantLvl = this.powerPlantLvl) and (this.planetTemplate.materialExtractorLvl = this.materialExtractorLvl) and (this.planetTemplate.warehouseLvl = this.warehouseLvl) and (this.planetTemplate.fuelGenLvl = this.fuelGenLvl) and (this.planetTemplate.fuelTankLvl = this.fuelTankLvl) and (this.planetTemplate.hangarLvl = this.hangarLvl) and areAllShipsUpgraded()
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

	_New(desiredShipLvl){
		this.shipLvl := 1
		this.desiredShipLvl := desiredShipLvl
	}
	
	isShipFullyUpgraded() {
		return (this.shipLvl = this.desiredShipLvl)
	}

}

