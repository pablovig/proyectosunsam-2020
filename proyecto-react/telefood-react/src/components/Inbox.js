import React, { useEffect, useState } from 'react'
import { MailTable } from './MailTable';
import { mailService } from "../services/mailService";
import { Busqueda } from './Busqueda';
import { useHistory } from "react-router-dom";
import { usuarioService } from "../services/usuarioService";

export const Inbox = ({ setTituloComponent }) =>{
    const [textoBusqueda, setTextoBusqueda] = useState('')
    const [mails, setMails] = useState([])


    const cambiarLeido = async (mail) =>{
        await mailService.cambiarEstadoLeido(mail.id)      
        fetchMails()
    }

    const borrarMail = async (mail) =>{
      await mailService.delete(mail.id)     
      fetchMails()
  }

  const busqueda = async (textoABuscar) =>{
    setTextoBusqueda(textoABuscar)
  }

   useEffect(() => {
        fetchMails()
        setTituloComponent("Inbox")
      }, [textoBusqueda])

   const fetchMails = async () => {
      
        const mailsEncontrados = await mailService.getMails(textoBusqueda)
        setMails(mailsEncontrados)
        
    }

    return (
        
        <div>
            <Busqueda titulo="mensajes" busqueda={ async (texto) => busqueda(texto)} />
            <div className="p-text-bold p-mx-2 p-mt-2">Resultados de la búsqueda</div>
            <MailTable mails={mails} borrarMail={ async (mail) => borrarMail(mail)} alCambiarLeido={async (mail) => cambiarLeido(mail)}/>
    </div>

    )
}