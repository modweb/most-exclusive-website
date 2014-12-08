# Configure Accounts Template

    AccountsTemplates.configure({
      confirmPassword: true,
      enablePasswordChange: true,
      forbidClientAccountCreation: false,
      overrideLoginErrors: true,
      sendVerificationEmail: false,

      showAddRemoveServices: false,
      showForgotPasswordLink: false,
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

      texts: {
        button: {
          signUp: 'Register'
        },
        title: {
          forgotPwd: 'Recover Your Password'
        },
      }
    })
