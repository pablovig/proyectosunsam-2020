import { fireEvent, render, waitFor } from '@testing-library/react'
import React from 'react'
import { BrowserRouter, MemoryRouter, Router } from 'react-router-dom'
import { crearUsuario } from './crearUsuario'
import { usuarioService } from '../../services/usuarioService'
import { Login } from '../Login.js'
import userEvent from '@testing-library/user-event'
import { screen } from '@testing-library/dom'
import { act } from 'react-dom/test-utils'

const mockUsuario =  crearUsuario(2, 'Raul', 'Raulito96')
  
describe('LoginComponent', () => {
  describe('cuando el servicio responde correctamente', () => {
    test('Se loguea un usuario correctamente', async () => {

      usuarioService.loguearUsuario = () => Promise.resolve(mockUsuario)
      const pushSpy = jest.mock('react-router-dom', () => {
        const actual = require.requireActual('react-router-dom')
        return {
          ...actual,
          useHistory: () => ({ methods }),
        }
      })
      const location = { pathname: '/' };
      const { getByTestId } = render(<Login setTituloComponent={ () => {} }/>)
      await waitFor(() => {
        fireEvent.click(getByTestId('loguear'))
        expect(pushSpy).toBeCalledWith(`/home`)
        })
    })
    
    // test("clicking filter links updates product query params", () => {
    //   let testHistory, testLocation;
    //   render(
    //     <MemoryRouter initialEntries={["/my/initial/route"]}>
    //       <App />
    //       <Route
    //         path="*"
    //         render={({ history, location }) => {
    //           testHistory = history;
    //           testLocation = location;
    //           return null;
    //         }}
    //       />
    //     </MemoryRouter>,
    //     node
    //   );
    
    //   act(() => {
    //     // example: click a <Link> to /products?id=1234
    //   });
    
    //   // assert about url
    //   expect(testLocation.pathname).toBe("/products");
    //   const searchParams = new URLSearchParams(testLocation.search);
    //   expect(searchParams.has("id")).toBe(true);
    //   expect(searchParams.get("id")).toEqual("1234");
    // });
  })
})