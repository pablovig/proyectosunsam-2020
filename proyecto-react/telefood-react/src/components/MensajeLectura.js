import React, { useEffect, useState, useRef } from 'react'
import { MensajeTop } from './MensajeTop'
import { MensajeTextBox } from './MensajeTextBox'
import { useHistory, useParams } from "react-router-dom";
import { Mensaje } from "../domain/mensaje";
import { mailService } from "../services/mailService";
import { ErrorComponent } from './ErrorComponent'
import { Toast } from 'primereact/toast';


export const MensajeVista = ({setTituloComponent}) => {

    let params = useParams()
    let history = useHistory()
    const [mail, setMail] = useState(new Mensaje())
    const [error, setError] = useState(null)
    const myToast = useRef(null);

    const  getMail = async () =>{
        var mailObtenido 
        mailObtenido = (params.mensajeID !== undefined ) ? await mailService.getMailDeUsuario(params.mensajeID) : await mailService.getNuevoMail(params.usuarioID)
        setMail(mailObtenido)
        setTituloComponent(mail.titulo)
    }

    const showToast = (severityValue, summaryValue, detailValue) => {   
      myToast.current.show({severity: severityValue, summary: summaryValue, detail: detailValue});   
    }

    const cancelarEnvio = () => {   //Se utiliza para Escritura de Mail 
        setError(null)
        history.push(`/contactos`)
    }
        
    const aceptarEnvio = async () => {    //Se utiliza para Escritura de Mail     
        try {
            await mailService.sendMail(mail)
            setError(null)  
            showToast('success','Mensaje enviado correctamente')
        }catch(errorRecibido){
            setError(errorRecibido)
       } 
        
    }
    
    useEffect(() => {    
        getMail()
        },[]
    )

    return (
        <div>
            <div className="p-mt-3 p-mx-2">
             <Toast ref={myToast} />
                <MensajeTop mail={mail}/>
                
                <MensajeTextBox
                mail={mail} 
                cancelarEnvio={cancelarEnvio} 
                aceptarEnvio={ aceptarEnvio}
                setMensaje = {setMail}/>
                { error && <ErrorComponent className="p-d-flex" textoError="No se pudo enviar el mensaje" setError={(e) => setError(e)}/> }
            </div>     
        </div>     
    )
}
