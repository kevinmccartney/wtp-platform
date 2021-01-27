import React from 'react';
import { Route, useRouteMatch, Switch, Redirect } from 'react-router';
import { connect } from 'react-redux';
import { LoginView, CreateAccountView, ProfileView } from '../../views';
import { ProtectedRoute } from '../../../shared';
import { NotFound } from '../../../shared/components';
import { IStoreState } from '../../../core/models/store-state.interface';

export const AccountRouterComponent: React.FC<{
  authenticated: boolean;
}> = ({ authenticated }) => {
  const { path } = useRouteMatch();

  return (
    <Switch>
      <Route path={`${path}/login`} component={LoginView} />
      <Route path={`${path}/create`} component={CreateAccountView} />
      <ProtectedRoute
        isAuthed={authenticated}
        path={`${path}/profile`}
        component={ProfileView}
      />
      <Route path="/not-found" component={NotFound} />
      <Redirect to="/not-found" />
    </Switch>
  );
};

const mapStateToProps = (state: IStoreState) => ({
  authenticated: state.auth.authenticated,
});

export const AccountRouter = connect(mapStateToProps)(AccountRouterComponent);
