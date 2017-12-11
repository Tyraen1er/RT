static int	check_col_neg(__global t_rt *rt, t_ray *ray, int hit)
{
	int			i = -1;
	while (rt->objects[hit].negative)
	{
		i = -1;
		while (++i < rt->nb_obj)
		{
			if (rt->objects[i].type == SPHERE)
				ft_sphere_col(rt->objects[i], ray, rt);
			else if (rt->objects[i].type == PLANE)
				ft_plane_col(rt->objects[i], ray, rt);
			else if (rt->objects[i].type == CONE)
				ft_cone_col(rt->objects[i], ray, rt);
			else if (rt->objects[i].type == CYLINDER)
				ft_cyl_col(rt->objects[i], ray, rt);
			if (ray->t < ray->dist)
			{
				hit = i;
				ray->dist = ray->t;
			}
		}
	}
}