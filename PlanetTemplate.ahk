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
	myPlanet.upgradePowerPlant()
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
			MouseClick, left, Px, Py
			this.powerPlantLvl := this.powerPlantLvl + 1
			;MsgBox, Found.
		} else {
			MsgBox, That color was not found in the specified region.
		}
	}
	
	upgradeMaterialExtractor() {
		
		this.materialExtractorLvl := this.materialExtractorLvl + 1
	}
	
	upgradeWareHouse() {
	
		this.warehouseLvl := this.warehouseLvl + 1
	}
	
	upgradeFuelGen() {
	
		this.fuelGenLvl := this.fuelGenLvl + 1
	}
	
	upgradeFuelTank() {
	
		this.fuelTankLvl := this.fuelTankLvl + 1
	}
	
	upgradeHanger() {
	
		this.hangarLvl := this.hangarLvl + 1
	}
	
	isFullyUpgraded() {
		return (this.planetTemplate.powerPlantLvl = this.powerPlantLvl) and (this.planetTemplate.materialExtractorLvl = this.materialExtractorLvl) and (this.planetTemplate.warehouseLvl = this.warehouseLvl) and (this.planetTemplate.fuelGenLvl = this.fuelGenLvl) and (this.planetTemplate.fuelTankLvl = this.fuelTankLvl) and (this.planetTemplate.hangarLvl = this.hangarLvl)
	}
	
}

Class Ship{

	_New(){
		this.shipLvl := 0
	}

}

