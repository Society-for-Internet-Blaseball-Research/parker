# Redirecting a service to outage.sibr.dev

If a service needs to be made inaccessible ASAP, you can quickly setup a redirect to https://outage.sibr.dev (hosted via the staticwww stack). 

Edit the service definition (in `stacks/`) of your target service.
- find any container with traefik routing labels, and edit them:
- comment out the proxy directive 
    ```
    traefik.http.services.<SERVICE_NAME>.loadbalancer.server.port: <PORT>
    ```
- setup the RedirectRegex traefik middleware with a catchall by adding two labels: 
    ```
    traefik.http.middlewares.<SERVICE_NAME>redirect.redirectregex.regex: "^.*"
    traefik.http.middlewares.<SERVICE_NAME>redirect.redirectregex.replacement: "https://outage.sibr.dev"
    ```
- add the middleware to the traefik router by adding a label:
    ```
    traefik.http.routers.<SERVICE_NAME>.middlewares: <SERVICE_NAME>redirect
    ```

If you can spare the time, make sure to edit the index.html file at `/srv/www/outage.sibr.dev` to contain the date of the outage as well as any important details.

Run the ansible playbook to update the server, as in the [ops manual](./ops.md).

### Reversing the redirect

- Remove all three new traefik labels.
- Uncomment the proxy label.
- Rerun the ansible playbook. 