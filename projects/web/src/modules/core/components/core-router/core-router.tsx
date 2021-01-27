import { Switch, Route } from 'react-router';
import React from 'react';
import { connect } from 'react-redux';
import { DashboardView } from '../../../dashboard/components';
import { AccountRouter } from '../../../account/components/account-router/account-router';
import { MessagingView } from '../../../messaging/components';
import { UsersView } from '../../../users/components';
import { ProtectedRoute } from '../../../shared/protected-route/protected-route';
import { IStoreState } from '../../models/store-state.interface';
import { NotFound } from '../../../shared/components';

export const CoreRouterComponent: React.FC<{
  authenticated: boolean;
}> = ({ authenticated }) => (
  <Switch>
    <ProtectedRoute
      path="/dashboard"
      exact
      component={DashboardView}
      isAuthed={authenticated}
    />
    <ProtectedRoute
      isAuthed={authenticated}
      path="/users"
      component={UsersView}
    />
    <Route path="/account" component={AccountRouter} />
    <ProtectedRoute
      isAuthed={authenticated}
      path="/messaging"
      component={MessagingView}
    />
    <Route component={NotFound} />
  </Switch>
);

const mapStateToProps = (state: IStoreState) => ({
  authenticated: state.auth.authenticated,
});

export const CoreRouter = connect(mapStateToProps)(CoreRouterComponent);
