import { Card } from 'primereact/card';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { Password } from 'primereact/password';
import React, { useEffect, useState } from 'react'
import { usuarioService } from '../services/usuarioService'
import { LoginUsuario } from "../domain/usuario";
import { useHistory,useParams } from "react-router-dom";
import { ErrorComponent } from './ErrorComponent'

export const Login = ({ setTituloComponent }) => {
    const [username, setUsername] = useState('')
    const [password, setPassword] = useState('')
    const [error, setError] = useState(null)
    let history = useHistory()
    let errorMessage 

    const loguearUsuario = async () => {
        const login = new LoginUsuario(username, password)
       try{
        await usuarioService.loguearUsuario(login)
        history.push('/home')
       }catch(error){
        setError(error)
       }
    }

    useEffect(() => {    
        setTituloComponent("")
        setError(null)
        },[]
    )

    return (
        <div className="card-contenedor p-d-flex p-flex-column p-ai-center p-jc-center ">    
            <Card className="p-d-flex p-jc-center p-mx-6 p-flex-column ancho" >
                <div className="p-d-flex p-jc-center p-flex-column bordesredondeados">
                    <div className="p-mb-2 p-text-center fuentelogo p-text-bold" >TeleFood</div>
                    <div className="p-text-center">
                        <i className="pi pi-user p-pr-2 tamañoiconos letrablanca"></i>
                        <InputText className="p-mb-2 p-inputtext-sm" data-testid="username" placeholder="Username" value={username} onChange={(event) => setUsername(event.target.value)} />
                    </div>
                    <div className="p-text-center">
                        <i className="pi pi-lock p-pr-2 tamañoiconos letrablanca"></i>
                        <Password className="p-mb-2 p-inputtext-sm" data-testid="password" placeholder="Password" feedback={false} value={password} onChange={(event) => setPassword(event.target.value)}/>
                    </div>
                    
                    <Button label="Ingresar" className="p-mx-auto  p-mt-2 boton" data-testid="loguear" onClick={loguearUsuario}/>
                </div>
                
                {/* {errorMessage && <div class="error" ><i class="fa fa-times-circle"></i>{ errorMessage }</div>} */}
            </Card>  
            <div className="errorLogin">
                { error && <ErrorComponent className="p-d-flex w-100" textoError="Error al intentar acceder" setError={(e) => setError(e)}/> }    
            </div>
        </div>
    ) 
}
