---
title: "Testing email sending with Jest, nodemailer, Node and TypeScript 📩"
date: 2024-01-25T07:37:55+04:00
draft: false
---

Ever since I started to do Test-driven development(TDD) I am encountered various issues regarding which I cannot find definitive solutions, so I will write my own.

Last time, I couldn’t make nodemailer to work with jest.


So imagine you have this REST API endpoint under `/api/send-email` you want to test.

```ts
import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: 'smtp.host.com',
  port: 465,
  secure: true,
  auth: {
    user: 'REPLACE-WITH-YOUR-ALIAS@YOURDOMAIN.COM',
    pass: 'REPLACE-WITH-YOUR-GENERATED-PASSWORD',
  },
});


const sendEmail = async (req: Request, res: Response) => {
  const  email = 'some-email@mail.com';

  try {
    await transporter.sendMail({
      from: `"Test email content" <${process.env.EMAIL_URL}>`,
      to: email,
      subject: 'Hello from test email.',
      text: `This is a test email, thank you.`,
      html: `
      This is a test email,
      <br>
      thank you.
      `,
    });

    res.status(200).send({ message: 'Please check your email.' });
  } catch (err) {
    res.status(400).send({ error: { message: 'Something went wrong.' } });
  }
};
```

## Now let's test it with Jest.

```ts
import { htmlToText } from 'html-to-text'; // in order to test html content

// for some js reason this doesn't work with let
var sendMailMock: jest.Mock;

// mocking nodemailer
jest.mock('nodemailer', () => {
  return {
    __esModule: true, // this line makes it work!
    default: {
      createTransport: () => {
        // be sure to use promise
        sendMailMock = jest.fn((mail: Mail) => Promise.resolve(mail));
        return { sendMail: sendMailMock };
      },
    },
  };
});


beforeEach(() => {
  sendMailMock.mockClear();
});

describe('{email test}', () => {
  test('POST /api/send-email should  send an email', async () => {
    const email = 'some-email@mail.com'
    const body = {};
    const response = await request(app)
        .post('/api/send-email')
        .send(body);

    expect(response.status).toBe(200);

    // checking the argument that was passed to the sendMail function
    const [args] = sendMailMock.mock.calls[0] as any;

    expect(sendMailMock).toHaveBeenCalled();
    expect(args.to).toBe(email);
    expect(args.subject).toBe('Hello from test email.');

    const htmlText = htmlToText(args.html);

    expect(htmlText).not.toBe('');

    const emailContaingTexts = [
      'This is a test email,',
      'thank you.'
    ];

    emailContaingTexts.forEach((emailContaingText) =>
      expect(htmlText).toContain(emailContaingText),
    );
  });
});
```

# This way you can test any aspect of email sending. 