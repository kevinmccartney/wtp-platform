import React from 'react';
import { Layout, Menu, Dropdown, Button } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPizzaSlice } from '@fortawesome/free-solid-svg-icons';
import { Link, withRouter } from 'react-router-dom';

import './app-shell.css';
import { RouteComponentProps } from 'react-router';
import { connect } from 'react-redux';
import { Dispatch } from 'redux';
import { IStoreState } from '../../models/store-state.interface';
// import { Auth } from 'aws-amplify';
import { logout } from '../../store/auth';

const menu = (cb: () => void) => (
  <Menu>
    <Menu.Item>
      <Link to="/account/profile">Profile</Link>
    </Menu.Item>
    <Menu.Item>
      <Button onClick={() => cb()}>Logout</Button>
    </Menu.Item>
  </Menu>
);

const AppShellComponent: React.FC<
  {
    isAuthed: boolean;
    dispatch: Dispatch;
  } & RouteComponentProps
> = ({ children, location, isAuthed, history, dispatch }) => {
  const { pathname } = location;

  const signOut = async () => {
    try {
      const user = new Promise((res, rej) => res({}));

      console.log(user);
      dispatch(logout());
      history.push('/account/login');
    } catch (error) {
      console.log('error signing out', error);
    }
  };

  return (
    <Layout className="h-screen">
      <Layout.Header className="flex">
        <Link to="/dashboard" className="flex items-center mr-4">
          <FontAwesomeIcon
            icon={faPizzaSlice}
            size="lg"
            className="text-white h-5 w-5"
          />
        </Link>
        {isAuthed ? (
          <>
            <Menu
              className="flex-grow-1"
              mode="horizontal"
              theme="dark"
              style={{ lineHeight: '64px' }}
            >
              <Menu.Item
                className={
                  pathname === '/messaging'
                    ? 'main-menu-item__active'
                    : 'main-menu-item'
                }
              >
                <Link to="/messaging">Messaging</Link>
              </Menu.Item>
              <Menu.Item
                className={
                  pathname === '/users'
                    ? 'main-menu-item__active'
                    : 'main-menu-item'
                }
              >
                <Link to="/users">Users</Link>
              </Menu.Item>
            </Menu>

            <Dropdown overlay={menu(signOut)}>
              <button
                className="ant-dropdown-link"
                onClick={(e) => e.preventDefault()}
                type="button"
              >
                <UserOutlined
                  className="text-white"
                  style={{ fontSize: '24px' }}
                />
              </button>
            </Dropdown>
          </>
        ) : undefined}
      </Layout.Header>
      <Layout className="p-6 items-center">{children}</Layout>
      <Layout.Footer className="p-6">footer</Layout.Footer>
    </Layout>
  );
};

const AppShellWithRouter = AppShellComponent;
const mapStateToProps = (state: IStoreState) => ({
  isAuthed: state.auth.authenticated,
});
const AppShell = withRouter(connect(mapStateToProps)(AppShellWithRouter));

export { AppShell };
