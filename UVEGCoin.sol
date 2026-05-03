// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UVEGCoin {

    // Dirección del creador del contrato
    address public creador;

    // Saldos de cada cuenta
    mapping (address => uint) public saldos;

    // Datos de la moneda
    string public nombre = "UVEG Coin";
    string public simbolo = "UC";

    // Evento para registrar envíos
    event Enviar(address origen, address destino, uint cantidad);

    // NUEVO EVENTO: para registrar comisiones
    event ComisionCobrada(address cuenta, uint monto);

    constructor() {
        creador = msg.sender;
        saldos[msg.sender] = 1000; // saldo inicial
    }

    // Función para generar monedas (solo el creador)
    function generar(address receptor, uint cantidad) public {
        require(msg.sender == creador, "Solo el creador puede generar monedas.");
        saldos[receptor] += cantidad;
    }

    // NUEVA FUNCIONALIDAD:
    // Cada vez que alguien envía monedas, se cobra una comisión del 1%
    // Esa comisión se envía automáticamente al creador del contrato.
    function enviar(address receptor, uint cantidad) public {
        require(cantidad <= saldos[msg.sender], "Saldo insuficiente.");

        // Cálculo de comisión (1%)
        uint comision = cantidad / 100;

        // Cantidad final que recibe el destinatario
        uint cantidadFinal = cantidad - comision;

        // Descuento al que envía
        saldos[msg.sender] -= cantidad;

        // El receptor recibe la cantidad menos la comisión
        saldos[receptor] += cantidadFinal;

        // La comisión se envía al creador
        saldos[creador] += comision;

        emit Enviar(msg.sender, receptor, cantidadFinal);
        emit ComisionCobrada(msg.sender, comision); // Comentario: registra la comisión cobrada
    }

    // Consultar saldo
    function obtenerSaldo(address cuenta) public view returns(uint) {
        return saldos[cuenta];
    }
}
