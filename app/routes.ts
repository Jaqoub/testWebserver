import { type RouteConfig, index, route } from "@react-router/dev/routes";

export default [
  index("routes/home.tsx"),
  route("api/instance", "routes/api.instance.ts"),
] satisfies RouteConfig;
