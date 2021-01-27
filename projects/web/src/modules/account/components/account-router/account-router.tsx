import React from 'react';
import { Route, useRouteMatch, Switch } from 'react-router';
import { connect } from 'react-redux';
import { IStoreState } from '@modules/core/models/store-state.interface';
import { LoginView, CreateAccountView, ProfileView } from '../../views';
import { ProtectedRoute } from '../../../shared';
import { NotFound } from '../../../shared/components';

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
      <Route component={NotFound} />
    </Switch>
  );
};

const mapStateToProps = (state: IStoreState) => ({
  authenticated: state.auth.authenticated,
});

export const AccountRouter = connect(mapStateToProps)(AccountRouterComponent);
