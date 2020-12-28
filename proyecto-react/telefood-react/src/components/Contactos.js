import React, { useEffect, useState } from 'react'
import { Button } from 'primereact/button'
import { usuarioService } from "../services/usuarioService";
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import { useHistory } from "react-router-dom";
import { Busqueda } from './Busqueda';

export const Contactos = ({setTituloComponent}) =>{
    const [textoBusqueda, setTextoBusqueda] = useState('')
    const [contactos, setContactos] = useState([])
    let history = useHistory();

  const busqueda = async (textoABuscar) =>{
    setTextoBusqueda(textoABuscar)
  }

   useEffect(() => {
        fetchUsuarios()
        setTituloComponent("Contactos")
      }, [textoBusqueda])

   const fetchUsuarios = async () => {
        const usuarios = await usuarioService.getUsuarios(textoBusqueda)
        const usuariosSinLogueado = await usuarioService.getUsuariosSinLogueado(usuarios)
        setContactos(usuariosSinLogueado)
    }
    
    const elegirContacto = (id) => {
        history.push(`/nuevoMensaje/${id}`)
    }

    const volverAtras = () => {
        history.push(`/home`)
    }

    return (
        
        <div>
            <Busqueda titulo="contactos" busqueda={ async (texto) => busqueda(texto)}/>
            <div className="p-text-bold p-mx-2 p-my-3">Resultados de la búsqueda</div>

            <table className="tabla">
            <tbody>
                <tr className="contactostr">
                  { contactos.map((contacto) =>
                  <td  className="dentrotabla" key={contacto.id} data-testid={'contacto_' + contacto.id} onClick={() => elegirContacto(contacto.id)}>{contacto.nombreYApellido}</td>
                   )}
                </tr>
                </tbody>
            </table>

            <div className="derecha">
            <Button className="p-mt-2 boton p-d-flex" onClick={volverAtras}>Cancelar</Button>
            </div>

        </div>

    )
}
