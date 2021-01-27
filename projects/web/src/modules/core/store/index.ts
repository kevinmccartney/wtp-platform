import { combineReducers } from 'redux';
import { connectRouter } from 'connected-react-router';
import { History } from 'history';
import authReducer from './auth';

export const createRootReducer = (history: History) =>
  combineReducers({
    auth: authReducer,
    router: connectRouter(history),
  });
