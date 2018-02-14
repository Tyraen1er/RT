/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   shadows.cl                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/13 15:05:50 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/04 18:32:51 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

/*void		ft_refract_shadow(t_rt *tmp, int i, t_light *light)
{
	t_vector	n;
	t_vector	hit;
	t_vector	v;

	hit = tmp->ray.pos + (tmp->ray.dir * tmp->ray.dist);
	v = light->pos - hit;
	n = ft_normale(tmp, &tmp->objects[i], hit);
	ft_refract_ray(tmp, 1.0, tmp->objects[i].refract, n);
	ft_check_collisions(tmp, tmp->objects, tmp->lights);
	tmp->ray.pos = tmp->ray.pos + (tmp->ray.dir * (tmp->ray.dist - 0.01));
	tmp->ray.t = 2000000.0;
	v = light->pos - hit;
	tmp->ray.dist = sqrt(dot(v, v));
	tmp->ray.id = -1;
	ft_refract_ray(tmp, tmp->objects[i].refract, 1.0, n);
}*/

static double	ft_shadow_col(t_rt *tmp, t_ray *r)
{
	int			i = -1;
	t_ray		ray = *r;
	t_object	*objs = tmp->objects;

	while (++i < tmp->nb_obj)
	{
		ray.t = r->dist;
		if (tmp->objects[i].type == SPHERE)
			ft_sphere_col(tmp->objects[i], &ray);
		else if (tmp->objects[i].type == PLANE)
			ft_plane_col(tmp->objects[i], &ray);
		else if (tmp->objects[i].type == CONE)
			ft_cone_col(tmp->objects[i], &ray);
		else if (tmp->objects[i].type == CYLINDER)
			ft_cyl_col(tmp->objects[i], &ray);
		else if (tmp->objects[i].type == CUBE)
			ft_cube_col(tmp->objects[i], &ray);
		if (ray.t < r->dist && tmp->objects[i].negative)
			check_col_neg((__global t_rt*)tmp, &ray, i);
		if (ray.id != -1 && ray.t < r->dist && ray.t > 0.0 && !objs[i].refract && !objs[i].transp)
			return (1.0);
		if (ray.id != -1 && ray.t < r->dist && ray.t > 0.0 && objs[i].transp)
			return (1.0 - objs[i].transp / 100.0);
	}
	return (0.0);
}

static double	ft_soft_shadows(__global t_rt *rt, const t_vector hit, __global t_light *light, __constant double *rand)
{
	t_vector		v;
	t_rt			save = *rt;
	t_ray			tmp;
	t_vector		r;
	int				i = -1;
	double			l = 0.0;
	const double	d = min(max(fabs(dot(hit, light->pos) / 10.0), 2000.0), 150.0);

	while (++i < d)
	{
		tmp.t = 2000000.0;
		r = (t_vector)(rand[i % MAX_RAND] * (d / 1000.0), rand[(i + 1) % \
			MAX_RAND] * (d / 1000.0), rand[(i + 2) % MAX_RAND] * (d / 1000.0));
		v = (light->pos + r) - hit;
		tmp.dist = sqrt(dot(v, v));
		tmp.t = tmp.dist;
		tmp.dir = normalize(v);
		tmp.pos = hit;
		l += ft_shadow_col(&save, &tmp);
	}
	return (l / d);
}

static double	ft_hard_shadows(__global t_rt *rt, const t_vector hit, __global t_light *light)
{
	const t_vector	v = light->pos - hit;
	t_rt		save = *rt;
	t_ray		r2;

	r2.t = 2000000.0;
	r2.dist = sqrt(dot(v, v));
	r2.t = r2.dist;
	r2.dir = normalize(v);
	r2.pos = hit;
	return (ft_shadow_col(&save, &r2));
}
