class EspacioUrbano {
	var property nombre = "Espacio Urbano"
	var property valuacion = 10000
	var property espacioLibre = 30
	var property tieneVallado = false
	var property trabajosRealizados = []
	 
	method superficie() = espacioLibre + self.espacioDeUsoEspecifico()
	
	method espacioDeUsoEspecifico()
	
	method esGrande() = self.superficie() > 50 && self.requerimientoEspecifico()
	
	method requerimientoEspecifico()
	
	method registrarTrabajo(trabajador,profesion) = if (self.validacion(profesion)) { 
		trabajosRealizados.add(new Trabajo (fecha = new Date(), trabajador = trabajador.nombre(), profesion = profesion, duracion = profesion.duracion(self), costo = profesion.costo(self)))
		profesion.trabajoCumplido(self)
		} else throw new DomainException(message = "No se pudo registrar el trabajo porque no pasó la validación requerida")
	
	method validacion(profesion) = profesion.trabajaSi(self) 
	
	method trabajosUltimoMes() = trabajosRealizados.filter {trabajo => trabajo.fecha().between(new Date().minusMonths(1),new Date())}
	
	method usoIntensivo() = self.trabajosUltimoMes().filter {trabajo => trabajo.esHeavy(self)}.size() > 5 
}

object plaza inherits EspacioUrbano {
	var property espacioDeEsparcimiento = 20
	var property cantidadCanchas = 2
	
	override method espacioDeUsoEspecifico() = espacioDeEsparcimiento
	
	override method requerimientoEspecifico() = cantidadCanchas > 2 
}

object plazoleta inherits EspacioUrbano {
	var property espacioSinCesped = 15
	var property procer
	
	override method espacioDeUsoEspecifico() = espacioSinCesped
	
	override method requerimientoEspecifico() = procer == "San Martín" && tieneVallado == true 
}

object anfiteatro inherits EspacioUrbano {
	var property escenario = 25
	var property capacidad = 350
	
	override method espacioDeUsoEspecifico() = escenario
	
	override method requerimientoEspecifico() = capacidad > 500
}

class Multiespacio inherits EspacioUrbano {
	const property espaciosUrbanos = []
	
	method agregarEspacio(espacio) = espaciosUrbanos.add(espacio)
	
	override method superficie() = espaciosUrbanos.sum {espacio => espacio.superficie()}
	
	override method espacioLibre() = espaciosUrbanos.sum {espacio => espacio.espacioLibre()}
	
	override method espacioDeUsoEspecifico() = espaciosUrbanos.sum { espacio => espacio.espacioDeUsoEspecifico() } 
	
	override method requerimientoEspecifico() = espaciosUrbanos.all {espacio => espacio.requerimientoEspecifico()}
}

class Trabajo {
	var property fecha
	var property trabajador
	var property profesion
	var property duracion
	var property costo
	
	method esHeavy(espacio) = profesion.esHeavy(espacio)
}


class Trabajador {
	var property nombre
	var property profesion
}


class Profesion {
	var property tarifaPorHora = 100
	
	method duracion(espacio)
	
	method trabajaSi(espacio)
	
	method trabajoCumplido(espacio)
	
	method costo(espacio) = self.duracion(espacio) * tarifaPorHora
	
	method esHeavy(espacio) = self.costo(espacio) > 10000
}

object cerrajero inherits Profesion {
	
	override method duracion(espacio) = if (espacio.esGrande()) 5 else 3  	
	
	override method trabajaSi(espacio) = !espacio.tieneVallado()
	
	override method trabajoCumplido(espacio) { espacio.tieneVallado(true) }
	
	override method esHeavy(espacio) = super(espacio) || self.duracion(espacio) > 5 
}

object jardinero inherits Profesion {
	
	var property tarifa = 2500
	
	override method duracion(espacio) = espacio.superficie() / 10
	
	override method trabajaSi(espacio) = (espacio !== plazoleta || espacio !== anfiteatro) && self.requerimientoEspecial(espacio)
	
	method requerimientoEspecial(espacio) = if (espacio == plaza) { espacio.cantidadCanchas() == 0 } else { espacio.espaciosUrbanos().size() > 3 }
	
	override method trabajoCumplido(espacio) { espacio.valuacion(espacio.valuacion() * 1.10) }
	
	override method costo(espacio) = tarifa
}

object encargadoDeLimpieza inherits Profesion {
	var property diasDeTrabajo = 1
	
	override method duracion(espacio) = 8 * diasDeTrabajo 	
	
	override method trabajaSi(espacio) = anfiteatro.esGrande() || espacio == plaza // como llamo a una instancia de una clase? o a una clase para compararla
	
	override method trabajoCumplido(espacio) { espacio.valuacion(espacio.valuacion() + 5000) }
}
