import nodemailer from "nodemailer";

const from = '"DomainEmail" <info@emaildomain.com>';

const {
  HOST, EMAIL_HOST, EMAIL_PORT, EMAIL_USER, EMAIL_PASS
} = process.env;

function setup() {
  return nodemailer.createTransport({
    host: EMAIL_HOST,
    port: EMAIL_PORT,
    auth: {
      user: EMAIL_USER,
      pass: EMAIL_PASS
    }
  });
}

export function sendResetSecureEmail(user) {
  const email = {
    from, to: user.email,
    subject: "Reset Password",
    html: `
    <b>Hi ${user.name},</b><br />
    <p>
    Thank you for submitting a request to reset your password.
    <br />Here is your confirmation code: ${user.confirmationCode}<br />
    <p>Regards, <br />System Admin</p>
    `
  };

  const transport = setup();
  transport.sendMail(email)
}

export function sendResetSecureCompletedEmail(user) {
  const email = {
    from, to: user.email,
    subject: `Reset ${user.type} completed`,
    html: `
    <b>Hi ${user.name},</b><br/>
    <p>
    Reset ${user.type} completed, please verify.<br/>
    <p>Regards, <br />System Admin</p>
    `
  };

  const transport = setup();
  transport.sendMail(email)
}
