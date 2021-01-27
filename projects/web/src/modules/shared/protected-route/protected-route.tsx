import React from 'react';
import { Route, Redirect, RouteProps } from 'react-router-dom';

export const ProtectedRoute: React.FC<
  {
    component: React.FC;
    isAuthed: boolean;
  } & RouteProps
> = ({ isAuthed, component, path, ...rest }) => {
  const TargetComponent = component;

  console.log('protected route');

  return (
    <Route
      path={path}
      {...rest}
      render={() => {
        if (isAuthed) {
          return <TargetComponent />;
        }
        return (
          <Redirect
            to={{
              pathname: '/account/login',
            }}
            push
          />
        );
      }}
    />
  );
};

export default ProtectedRoute;
