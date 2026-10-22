# Lamination Hub NFC Studio

A starter multi-customer digital visiting-card website with a single admin panel, powered by Supabase and suitable for GitHub Pages static hosting.

## Included
- Public customer profile links: `https://YOUR-SITE/?p=customer-slug`
- Admin email/password login
- Create, edit, search, preview, activate/deactivate, and delete customer profiles
- Profile-specific branding, logo/photo URL, contact info, WhatsApp, map, social links, services and payment link
- Save contact as a vCard, share profile and create a QR code
- One profile URL can be written to an NFC tag and printed as a QR code

## 1. Configure Supabase
1. Open the Supabase project you want to use.
2. Review the existing `public.admin_users` and `public.card_profiles` tables first to avoid overwriting existing work.
3. In SQL Editor, run `schema.sql`. If you already have an `admin_users` table with a different structure, adapt the SQL instead of replacing existing tables.
4. In Authentication > Users, create an admin login.
5. Copy that user's UUID and run:
   ```sql
   insert into public.admin_users(user_id)
   values ('YOUR-AUTH-USER-UUID')
   on conflict do nothing;
   ```
6. In Project Settings / API, copy the Project URL and publishable key (or legacy anon key). Never use a `service_role` or secret key in browser code.

## 2. Configure the website
Open `index.html` and replace:
- `YOUR_SUPABASE_PROJECT_URL`
- `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY`

The site uses Supabase JS v2 from a CDN.

## 3. Publish on GitHub Pages
1. Upload `index.html`, `schema.sql`, and this README to a GitHub repository.
2. Open repository Settings > Pages.
3. Select deployment from your main branch and root folder.
4. Save and wait for the public URL.

GitHub Pages serves static files; Supabase provides shared online storage and authentication. Admin changes will then appear to visitors from every device.

## 4. Create a customer NFC card
1. Sign in to Admin Panel and create a customer profile.
2. Use a short unique slug, such as `rahul-mobile-shop`.
3. Copy the public URL, for example `https://YOUR-SITE/?p=rahul-mobile-shop`.
4. Write that exact URL to the NFC tag with an NFC-writing app, and print a QR code for the same URL.
5. Test the link on a phone that is not signed in.

## Important notes
- This starter is preconfigured with the existing Lamination Hub Supabase project URL and its public publishable key. The Supabase project was requested to be restored but was still coming online during setup; database schema inspection and migration have not yet been completed. Do not consider the live backend ready until schema setup and tests succeed.
- Profile photo/logo fields currently accept image URLs. Add a Supabase Storage bucket and upload workflow if you want direct file uploads.
- The QR code helper uses a third-party QR image endpoint. For production privacy, use a local QR library or your own QR generation endpoint.
- Do not publish private customer data without permission. Only put information the customer has agreed to display publicly.
- RLS policies protect profile editing; only UUIDs inserted in `admin_users` can manage all profiles.
