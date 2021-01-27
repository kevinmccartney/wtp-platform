import React from 'react';
import { Form, Input, Button, Checkbox, Card } from 'antd';
import { UserOutlined, LockOutlined } from '@ant-design/icons';
import './login.css';
// import { Auth } from 'aws-amplify';
import { Dispatch } from 'redux';
import { connect } from 'react-redux';
import { withRouter, RouteComponentProps } from 'react-router';
import { login } from '../../../core/store/auth';

export const LoginViewComponent: React.FC<
  {
    dispatch: Dispatch;
  } & RouteComponentProps
> = ({ dispatch, history }) => {
  // TODO: remove any type
  // eslint-disable-next-line
  const signIn = async (values: any) => {
    try {
      // const user = await Auth.signIn(values.username, values.password);

      const user = new Promise((res, rej) => res({}));

      console.log(user);
      dispatch(login());
      history.push('/dashboard');
    } catch (error) {
      console.log('error signing in', error);
    }
  };

  return (
    <div className="LoginViewComponent">
      <Card className="min-w-14">
        <Form
          name="normal_login"
          className="login-form"
          initialValues={{ remember: true }}
          onFinish={signIn}
        >
          <Form.Item
            name="username"
            rules={[{ required: true, message: 'Please input your Username!' }]}
          >
            <Input
              prefix={<UserOutlined className="site-form-item-icon" />}
              placeholder="Username"
            />
          </Form.Item>
          <Form.Item
            name="password"
            rules={[{ required: true, message: 'Please input your Password!' }]}
          >
            <Input.Password
              prefix={<LockOutlined className="site-form-item-icon" />}
              type="password"
              placeholder="Password"
            />
          </Form.Item>
          <Form.Item className="flex justify-between">
            <Form.Item name="remember" noStyle>
              <Checkbox disabled>Remember me</Checkbox>
            </Form.Item>

            <a className="login-form-forgot" href="/forgot-password">
              Forgot password
            </a>
          </Form.Item>

          <Form.Item>
            <Button
              type="primary"
              htmlType="submit"
              className="login-form-button w-full"
            >
              Log in
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
};

export const LoginView = withRouter(connect()(LoginViewComponent));
