▶️ RUN IT
chmod +x cf_create_random_emails_and_export.sh
./create_random_emails_and_export.sh





📄 Output File Example (created_emails.txt)
x9f2qk@proxyweb.dpdns.org
m7a0lp@proxyweb.dpdns.org
r4z9tw@proxyweb.dpdns.org
...

🔎 VERIFY
API
curl -s \
"https://api.cloudflare.com/client/v4/zones/0848c8b48cfd5cb558ee23c224921702/email/routing/rules" \
-H "Authorization: Bearer YOUR_API_TOKEN"

UI

Cloudflare Dashboard →
Email → Email Routing → Custom addresses
✔ 50 new randomized entries visible

🧠 Notes (Important)

UI says “Custom address”

API object is Email Routing RULE

Export file contains only successfully created addresses

Random names → collision probability is negligible

🔐 Security Recommendation

After confirming success:

Cloudflare → My Profile → API Tokens → Roll token
