/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   negative.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eferrand <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/12/12 17:01:02 by eferrand          #+#    #+#             */
/*   Updated: 2017/12/12 17:03:32 by eferrand         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void  check_col_neg(__global t_rt *rt, t_ray *ray, int hit)
{
	int         i = -1;
	int			oldhit = -1;
	t_ray       newray = *ray;

	while (rt->objects[hit].negative && oldhit != hit)
	{
		oldhit = hit;
//  on recupère les distances parcourues + taille de l'objet
		if (rt->objects[hit].type == SPHERE)
			ft_sphere_col(rt->objects[hit], ray);
		else if (rt->objects[hit].type == PLANE)
			ft_plane_col(rt->objects[hit], ray);
		else if (rt->objects[hit].type == CONE)
			ft_cone_col(rt->objects[hit], ray);
		else if (rt->objects[hit].type == CYLINDER)
			ft_cyl_col(rt->objects[hit], ray);
		ray->t += ray->otherside + 0.1;
//  création d'un nouveau rayon avec une nouvelle position
		newray.pos += ray->t * ray->dir;
		newray.t = 200000.0;
		newray.dist = 200000.0;

//  on relance les collisions
		i = -1;
		while (++i < rt->nb_obj)
		{
			if (rt->objects[i].type == SPHERE)
				ft_sphere_col(rt->objects[i], &newray);
			else if (rt->objects[i].type == PLANE)
				ft_plane_col(rt->objects[i], &newray);
			else if (rt->objects[i].type == CONE)
				ft_cone_col(rt->objects[i], &newray);
			else if (rt->objects[i].type == CYLINDER)
				ft_cyl_col(rt->objects[i], &newray);
			if (newray.t < newray.dist)
			{
				hit = i;
				newray.dist = newray.t;
			}
		}
		ray->id = hit;
		ray->t += newray.dist;
		ray->dist = ray->t;
	}
}
