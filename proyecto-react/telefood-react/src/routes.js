import { BrowserRouter as Router, Route } from 'react-router-dom'
import { Inbox } from './components/Inbox.js'
import { Login } from './components/Login.js'
import { Contactos } from './components/Contactos.js'
import { Header } from './components/Header'
import { Footer } from './components/Footer'
import { MensajeVista } from './components/MensajeLectura.js'
import React, { useEffect, useState } from 'react'
import { usuarioService } from "./services/usuarioService";


export const TeleFoodRoutes = () => {
    
    const [tituloComponent, setTituloComponent] = useState('')

    return(
    
    <Router>
        <Route >{usuarioService.usuarioLogueado && <Header tituloComponent={tituloComponent} nombrePerfil={usuarioService.usuarioLogueado.nombreYApellido}/>}</Route>
        <Route exact={true} path="/" > <Login setTituloComponent={(titulo) => setTituloComponent(titulo)}/> </Route>
        <Route path="/home" > <Inbox setTituloComponent={(titulo) => setTituloComponent(titulo)}/> </Route>
        <Route path="/contactos" > <Contactos setTituloComponent={(titulo) => setTituloComponent(titulo)}/> </Route>
        <Route path="/mensaje/:mensajeID"> <MensajeVista setTituloComponent={(titulo) => setTituloComponent(titulo)}/> </Route>
        <Route path="/nuevoMensaje/:usuarioID"> <MensajeVista setTituloComponent={(titulo) => setTituloComponent(titulo)}/> </Route>
        <Route><Footer/></Route>
    </Router>
    )
}
  

