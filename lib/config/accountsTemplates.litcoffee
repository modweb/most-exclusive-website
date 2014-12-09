# Configure Accounts Template

    AccountsTemplates.configure
      confirmPassword: true,
      enablePasswordChange: true,
      forbidClientAccountCreation: false,
      overrideLoginErrors: true,
      sendVerificationEmail: false,

      showAddRemoveServices: false,
      showForgotPasswordLink: true,
      showLabels: true,
      showPlaceholders: true,

      continuousValidation: false,
      negativeFeedback: false,
      negativeValidation: true,
      positiveValidation: true,
      positiveFeedback: true,
      showValidating: true,

      privacyUrl: 'privacy',
      termsUrl: 'terms-of-use',

      homeRoutePath: '/',
      redirectTimeout: 4000,

      texts:
        navSignIn: 'Sign In'
        navSignOut: 'Logout'
        button:
          signUp: 'Register'
        title:
          forgotPwd: 'Recover Your Password'
