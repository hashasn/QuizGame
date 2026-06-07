const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
  console.log(process.env.EMAIL_PORT);
  // 1) Create a transporter
  const transport = nodemailer.createTransport({
    host: 'sandbox.smtp.mailtrap.io',
    port: 2525,
    auth: {
      user: 'ca18307d2eaf52',
      pass: 'cf621ebc1714d9',
    },
  });
  console.log('done');
  // 2) Define the email options
  const mailOptions = {
    from: 'me ',
    to: options.email,
    subject: options.subject,
    text: options.message,
    // html:
  };
  console.log('done');
  // 3) Actually send the email
  await transport.sendMail(mailOptions);
};

module.exports = sendEmail;
