#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

p::
	main()
	return
o::
	ExitApp

main() {
	planetTemplate := new PlanetTemplate(10,10,10,10,10,1)
	allPlanetsComplete := false
	listOfPlanets := Array()
	listOfPlanets.Push(new Planet{planetTemplate))
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


Class Research() {

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
	
	upgrade() {
	
	}
	
	isFullyUpgraded() {
	}
	
}

Class Ship{

	_New(){
		this.shipLvl := 0
	}

}

