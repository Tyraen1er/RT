/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   refraction.cl                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/07 14:35:41 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/04 18:32:01 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void		ft_refract_ray(t_ray *ray, const double n1, const double n2, \
															const t_vector n)
{

	const double	cosd = -dot(ray->dir, n);
	const double	n3 = n1 / n2;
	double			a = n3 * n3 * (1.0 - cosd * cosd);

	if (a > 1.0)
		return ;
	a = sqrt(1.0 - a);
	ray->dir = ray->dir + (n3 * cosd - a) * n;
	ray->dist = 2000000.0;
	ray->t = ray->dist;
	normalize(ray->dir);
	
/*
	double		cosd = dot(n, ray->dir);
	double		n3;
	double		a;

	if (cosd < 0.0)
		cosd = -cosd;
	else
	{
		n = -n;
		n3 = n1;
		n1 = n2;
		n2 = n3;
	}
	n3 = n1 / n2;
	a = 1.0 - n3 * n3 * (1.0 - cosd * cosd);
	if (a < 0.0)
		return ;
	a = sqrt(a);
	ray->dir = ray->dir + (n3 * cosd - a) * n;
	ray->dist = 2000000.0;
	ray->t = ray->dist;*/
	
/*
	const double	r = pow((n1 - n2) / (n1 + n2), 2.0);
	double			cosd = -dot(n, ray->dir);
	double			n3;
	double			a;
	double			x;

	if (n1 > n2)
	{
		n3 = n1 /n2;
		a = n3 * n3 * (1.0 - cosd * cosd);
		if (a > 1.0)
			return ;
		cosd = sqrt(1.0 - a);
	}
	x = 1.0 - cosd;
	ray->dir = ray->dir + ((r + 1.0 - r) * x) * n;
	ray->id = -1;
	ray->dist = 2000000.0;
	ray->t = ray->dist;*/
}

static t_color		ft_refract_color(__global t_rt *rt, const double n1, const \
														double n2, t_ray *ray)
{
	const int		id = ray->id;
	const t_vector	hit = ray->pos + ray->dir * ray->dist;
	const t_vector	n = ft_normale(rt, &rt->objects[id], hit, ray, 0);

	ray->pos = hit;
	ft_refract_ray(ray, n1, n2, n);
	ft_check_collisions(rt, ray);
	if (ray->id == id)
	{
		ray->pos = ray->pos + ray->dir * ray->dist;
		ft_refract_ray(ray, n2, n1, n);
		ft_check_collisions(rt, ray);
		if (ray->id == -1)
			return ((t_color){0, 0, 0, 0xff000000});
	}
	if (ray->id != id && ray->id < rt->nb_obj)
		return (ft_color(rt, *ray, 1.0, 0));
	return ((t_color){0xff, 0xff, 0xff, 0xffffffff});
}