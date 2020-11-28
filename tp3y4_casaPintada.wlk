// Agencia y contratistas
object agencia {
	const property contratistas = #{veronica,marcos,francisca,jacques,raul,carla,venancio,viktor,judith,dodain}
	const property clientes = #{aldo,milena,damian,greta,valeria}
	
	method contratarEmpleado(contratista) = contratistas.add(contratista)
	
	method despedirEmpleado(contratista) = contratistas.remove(contratista)
	
	method presupuestoContratistas(contratista,casa) = contratista.costoPorTrabajo(casa)
	
	
	method aQuienLeAprobaronUnTrabajo(contratista) = clientes.filter {cliente => cliente.listaDeContratados().contains(contratista)}
	
	method aQuienLeRechazaronUnTrabajo(contratista) = clientes.filter {cliente => cliente.listaDeNoContratados().contains(contratista)}
	
	method serviciosSolicitados(contratista) = self.aQuienLeAprobaronUnTrabajo(contratista)+ self.aQuienLeRechazaronUnTrabajo(contratista)
	
	method reglaTresSimples(contratista) = self.aQuienLeAprobaronUnTrabajo(contratista).size() * 100 / self.serviciosSolicitados(contratista).size()
	
	method calcularPresupuestosAprobados(contratista) = "Tiene un " + self.reglaTresSimples(contratista).truncate(2) + "% de presupuestos aprobados." 
}

// Solucionar el tema del polimorfismo y el porcentaje de aprobados  [No es polimórfico y repite código]
                           
class Combo {
	const property contratistas = []

	method descuento() = if (contratistas.size().rem(2) == 0) 0.90 else 0.95
	method costoPorTrabajo(casa) = contratistas.sum {contratista => contratista.costoPorTrabajo(casa)}
	method costoTotal(casa) = self.costoPorTrabajo(casa) * self.descuento()
}

class Arquitecto {
	var property tarifa
	
	method costoPorTrabajo(casa) = tarifa * casa.pisos()
}

class MaestroMayorDeObra {
	var property tarifa = numeros.alAzar()
	
	method recargo(casa) = if (casa.esComplicada()) 1.20 else 1
	method costoPorTrabajo(casa) = tarifa * casa.cantidadAmbientes() * self.recargo(casa) 
}

class Albanil {
	var property tarifa = 100
	var property horasPorAmbiente 
	
	method costoPorTrabajo(casa) = horasPorAmbiente * casa.cantidadAmbientes() * tarifa	
}

const veronica = new Arquitecto (tarifa = 100000)

const viktor = new Arquitecto (tarifa = 75000)

const marcos = new MaestroMayorDeObra (tarifa = 50000)

const judith = new MaestroMayorDeObra()

const dodain = new Albanil (horasPorAmbiente = 8)

object francisca {
	
	method tarifa(casa) = if (casa.esComplicada()) 200 else 100
	method costoPorTrabajo(casa) = casa.cantidadAmbientes() * self.tarifa(casa)
}

object jacques {
	var property tarifa = 100
	
	method recargo(casa) = if (casa.cantidadAmbientes() > 3) 1.10 else 1
	method costoPorTrabajo(casa) = casa.cantidadAmbientes() * tarifa * self.recargo(casa)
}

object raul {
	var property tarifa = 70
	var property precioPintura
	
	method usarPintura(pintura,casa) {precioPintura = pintura.costo(casa)} 
	method manoDeObra(casa) = tarifa * casa.superficie()
	method costoPorTrabajo(casa) = self.manoDeObra(casa) + precioPintura
}

object carla {
	var property tarifa = 45
	
	method coeficienteDeSuperficie(casa) = if (casa.superficie() <= 25) 2 else 1.50 
	method costoPorTrabajo(casa) = tarifa * casa.superficie() * self.coeficienteDeSuperficie(casa)
}

object venancio {
	var property tarifa = 43
	var property precioPintura
	
	method usarPintura(pintura,casa) {precioPintura = pintura.costo(casa)} 
	method manoDeObra(casa) = tarifa * casa.superficie()
	method costoPorTrabajo(casa) = self.manoDeObra(casa) + 1/2 * precioPintura
}

// Pinturas
class Pintura {
	var property precio
	var property rendimiento	
	
	method cantidadNecesaria(casa) = (casa.superficie() / rendimiento).roundUp()
	method costo(casa) = self.cantidadNecesaria(casa) * precio 
}

const pinturaEnLata = new Pintura (precio = 500 , rendimiento = 50)
const pinturaPorMayor = new Pintura (precio = 12 , rendimiento = 2)

// Casas y habitaciones
class Casa {
	var property pisos
	var property cantidadAmbientes
	
	method superficie() = 41
	method esComplicada() = pisos > 2
}

object casaAldo inherits Casa(pisos = 2) {
	const property ambientes = [habitacion,cocina]
	
	override method cantidadAmbientes() = ambientes.size()
	override method superficie() = ambientes.sum {ambiente => ambiente.superficie()}
}

const casaDamian = new Casa (pisos = 4, cantidadAmbientes = 4)

object habitacion {
	method superficie() = 20
}

object cocina {
	const anchoCocina = 1
	const largoCocina = 2
	const alturaCocina = 3.5

	method superficie() = (anchoCocina + largoCocina ) * 2 * alturaCocina
}

// Definición de clientes
class Cliente {
	var property ahorros = 11000
	var property gastos = 0
	var property casa = casaAldo
	var property tipoDeCliente = criterioActual
	var property porcentajeParaInvertir = 0.20
	const property serviciosAprobados = []
	const property serviciosRechazados = []
	
	method agregarServicioAprobado(contratista) = serviciosAprobados.add(new Servicio( fecha = new Date(), monto = contratista.costoPorTrabajo(casa), contratista = contratista))
	
	method agregarServicioRechazado(contratista) = serviciosRechazados.add(new Servicio( fecha = new Date(), monto = contratista.costoPorTrabajo(casa), contratista = contratista))
	
	method presupuestoMaximo() = ahorros * porcentajeParaInvertir
	
	method nuevosAhorros(dineroExtra) {ahorros = ahorros + dineroExtra}
	
	method puedeContratarA(contratista) = tipoDeCliente.loContrataSi(contratista,casa,self)
	
	method modificarAhorros(contratista) {ahorros = ahorros - contratista.costoPorTrabajo(casa)}
	
	method contratarServicioDe(contratista) = if (self.puedeContratarA(contratista)) {
		self.agregarServicioAprobado(contratista)
		self.modificarAhorros(contratista) } else {
			self.agregarServicioRechazado(contratista)
			throw new DomainException(message = "No se pudo concretar la contratación")
		}
	
	
	method serviciosSolicitados() = (serviciosAprobados + serviciosRechazados)
			
	method reglaTresSimples() = serviciosAprobados.size() * 100 / self.serviciosSolicitados().size()
	
	method calcularPresupuestosAprobados() = "Tiene un " + self.reglaTresSimples() + "% de presupuestos aprobados." 	
	
	
	method fechaHoy() = new Date()
	
	method serviciosUltimaSemana() = serviciosAprobados.filter {servicio => servicio.fecha().between(self.fechaHoy().minusDays(7) ,self.fechaHoy())}
	
	method gastosUltimaSemana() {gastos = gastos + self.serviciosUltimaSemana().sum {servicio => servicio.monto()} }
	
	method listaDeContratados() = serviciosAprobados.map {servicio => servicio.contratista()}
	
	method listaDeNoContratados() = serviciosRechazados.map {servicio => servicio.contratista()}
	
	method esDescuidado() = serviciosAprobados.any {servicio => servicio.monto() > 5000}
}

object aldo inherits Cliente {}

object milena inherits Cliente {}

object greta inherits Cliente {}

object valeria inherits Cliente {}

object damian inherits Cliente (casa = casaDamian, ahorros = 250000) {
	
	override method esDescuidado() = super() && casa.pisos() < 3
}

// Criterios para definir los tipos de clientes

object criterioActual {	
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) <= cliente.presupuestoMaximo()	
}

class Inseguro {
	var property deHumor = false

	method estaDeHumor() {
		deHumor = !deHumor
		return deHumor
	}
	
	method loContrataSi(contratista,casa,cliente) = self.estaDeHumor() && contratista.costoPorTrabajo(casa) <= cliente.ahorros()
}

object derrochon {
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) > cliente.presupuestoMaximo()
}

object complicon {
	method loContrataSi(contratista,casa,cliente) = contratista.costoPorTrabajo(casa) % 7 == 0
}

// Definición de los servicios y números al azar
class Servicio {
	var property fecha
	var property monto
	var property contratista
}

object numeros {
	var property min = 30000
	var property max = 40000
	
	method alAzar() = min.randomUpTo(max) 
}
