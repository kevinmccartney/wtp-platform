const LOGIN = 'AUTH/LOGIN';
const LOGOUT = 'AUTH/LOGOUT';

export default function authReducer(state = initialState, action: AuthActions) {
  switch (action.type) {
    case LOGIN:
      return {
        authenticated: true,
      };
    case LOGOUT:
      return {
        authenticated: false,
      };
    default:
      return state;
  }
}

export const login = () => ({
  type: LOGIN,
});

export const logout = () => ({
  type: LOGOUT,
});

export type AuthActions = ReturnType<typeof login | typeof logout>;

const initialState: IAuthState = {
  authenticated: false,
};

export interface IAuthState {
  authenticated: boolean;
}
