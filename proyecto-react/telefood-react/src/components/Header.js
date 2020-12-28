import React, { useEffect, useState } from 'react'
import { Menubar } from 'primereact/menubar';
import { Button } from 'primereact/button';
import { usuarioService } from "../services/usuarioService";
import { withRouter } from 'react-router-dom'
import { useHistory } from "react-router-dom";

export const Header = ({ tituloComponent, nombrePerfil }) =>{
    let history = useHistory();

    const logOff = () =>{
        usuarioService.usuarioLogueado = null
        history.push('/')
    }

    const items =
    [
        {
            label: nombrePerfil,
            icon: 'pi pi-user',
            disabled: 'true',
            className: 'colorletranegra'
        },

        {
            label: 'Inbox',
            icon: 'pi pi-inbox',
            command: ()=> { history.push('/home') }
        },
        {
            label: 'Enviar',
            icon: 'pi pi-upload',
            command: ()=> { history.push('/contactos') }
        },
        {
            label: 'Salir',
            icon: 'pi pi-sign-out',
            command: ()=> { logOff() }
        }
    ]

        return (
            <header className="p-d-flex p-jc-between">
                <h1 className="fuentelogopequeña">TeleFood/ {tituloComponent}</h1>
                <Menubar model={items} popup className="sinbordes fondoprimario letrablanca p-d-flex p-jc-between"/>
            </header>
        )
}

export default withRouter(Header)