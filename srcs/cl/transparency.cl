/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   transparency.cl                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/30 16:31:26 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/04 17:46:29 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

t_color				ft_transp_color(__global t_rt *rt, t_ray *ray, __constant double *rand)
{
	const int		id = ray->id;

	ray->pos = ray->pos + ray->dir * ray->dist;
	ft_check_collisions(rt, ray);
	if (id == ray->id)
	{
		ray->id = -1;
		ray->t = 200000.0;
		ray->dist = ray->t;
		ft_check_collisions(rt, ray);
	}
	if (ray->id != id && ray->id < rt->nb_obj && ray->id > -1)
		return (ft_color(rt, *ray, 1.0, rand));
	else if (ray->id == -1)
		return ((t_color){0, 0, 0, 0});
	return ((t_color){0xff, 0xff, 0xff, 0xffffffff});
}

t_color				ft_transparency(__global t_rt *rt, const double transp, \
											t_ray *ray, __constant double *rand)
{
	t_color			c;
	const t_color	c2 = rt->objects[ray->id].color;
	const double	l = min(max(ft_light(rt, ray, rand), transp), 2.0);

	c = ft_transp_color(rt, ray, rand);
	c.r = min(max((((c2.r * (1.2 - transp)) + (c.r * transp * 0.8)) * l), 0.0), 255.0);
	c.g = min(max((((c2.g * (1.2 - transp)) + (c.g * transp * 0.8)) * l), 0.0), 255.0);
	c.b = min(max((((c2.b * (1.2 - transp)) + (c.b * transp * 0.8)) * l), 0.0), 255.0);
	c.c = 0xff << 24 | c.b << 16 | c.g << 8 | c.r;
	return (c);
	//if (ray->id != id && ray->id < rt->nb_obj)
	//	return (ft_color(rt, *ray, 1.0));
	//return ((t_color){0xff, 0xff, 0xff, 0xffffffff});
}