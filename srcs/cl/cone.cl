/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cone.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 17:12:25 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/08 16:34:51 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void			ft_cone_col(const t_object obj, t_ray *ray)
{
	const t_vector		dist = ray->pos - obj.pos;
	const t_vector		rot = obj.rot;
	t_ray				tmpray = *ray;
	t_equation			e = {
		.a = dot(ray->dir, ray->dir) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * pow(dot(ray->dir, rot), 2.0), \
		.b = 2 * (dot(ray->dir, dist) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * dot(ray->dir, rot) * dot(dist, rot)), \
		.c = dot(dist, dist) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * pow(dot(dist, rot), 2.0), \
		.delta = e.b * e.b - 4.0 * e.a * e.c
	};

	if (e.delta < 0.0 && !dot(ray->dir, obj.rot))
		return ;
	e.c = 0 < (-e.b + sqrt(e.delta)) / (2 * e.a) ? (-e.b + sqrt(e.delta)) / (2 * e.a) : ray->t;
	e.delta = 0 < (-e.b - sqrt(e.delta)) / (2 * e.a) ? (-e.b - sqrt(e.delta)) / (2 * e.a) : ray->t;
	if (e.delta < e.c)
	{
		e.b = e.c;
		e.c = e.delta;
		e.delta = e.b;
	}

/*	pour le code au dessus on cherche les collisions sur un cone double infini,
donc caracterise par un vecteur directeur et un angle en degre.
Normalement cette partie fonctionne nickel. C est la suite le probleme.

A savoir : 
e.c et e.delta sont les points de collisions du cone infini.
e.c < e.delta
En opencl je peux faire des calculs de vecteurs rapidement, exemple : v = v1 + v2 * v3
*/

// obj.size.x = angle en degré par rapport au vecteur directeur obj.rot
// obj.size.y = taille du cone double en hauteur, donc s il est infini ou non
// obj.size.z = determine si on fait un cone simple ou double mais cette partie n est pas fonctionnel. Donc on travaille que sur du double.
	if (obj.size.y && !obj.size.z)
	{
		if (dot(ray->dir, obj.rot))
		{
// j'appelle une fonction qui me donne les collisions d un rond de la meme taille que les bases de mes cones.
//
			ft_plane_col((const t_object){obj.pos + obj.rot * obj.size.y / 2, obj.rot, (t_vector){obj.size.y / 2 * tan(obj.size.x * M_PI / 180), 0, 0}}, &tmpray);
// Si la collision avec le rond est derriere moi, donc < 0
// puis je fais attention a la regle e.c < e.delta
			if (0 < tmpray.t)
			{
				if (tmpray.t < e.delta)
					e.delta = tmpray.t;
				if (e.delta < e.c)
				{
					e.b = e.c;
					e.c = e.delta;
					e.delta = e.b;
				}
			}
			tmpray.t = ray->t;

// fonction collision avec un rond, mais positionné a un endroit different.
			ft_plane_col((const t_object){obj.pos - obj.rot * obj.size.y / 2, obj.rot, (t_vector){obj.size.y / 2 * tan(obj.size.x * M_PI / 180), 0, 0}}, &tmpray);
			if (0 < tmpray.t)
			{
				if (tmpray.t < e.delta)
					e.delta = tmpray.t;
				if (e.delta < e.c)
				{
					e.b = e.c;
					e.c = e.delta;
					e.delta = e.b;
				}
			}
		}

// je verifie que les points de collisions trouves sont compris dans un cone double limite ou sur un des ronds (plan limite) qui le ferment
		if (obj.size.y / 2 < length(ray->pos + ray->dir * e.c - obj.pos))
			return ;
	}
/*	else if (obj.size.y && obj.size.z)
	{
		if (dot(ray->dir, obj.rot))
		{
			ft_plane_col((const t_object){obj.pos + obj.rot * obj.size.y / 2, obj.rot, (t_vector){obj.size.y / 2* tan(obj.size.x * M_PI / 180), 0, 0}}, &tmpray);
			if (0 < tmpray.t)
			{
				if (tmpray.t < e.delta)
					e.delta = tmpray.t;
				if (e.delta < e.c)
				{
					e.b = e.c;
					e.c = e.delta;
					e.delta = e.b;
				}
			}
			tmpray.t = ray->t;
			ft_plane_col((const t_object){obj.pos - obj.rot * obj.size.y / 2, obj.rot, (t_vector){obj.size.y / 2* tan(obj.size.x * M_PI / 180), 0, 0}}, &tmpray);
			if (0 < tmpray.t)
			{
				if (tmpray.t < e.delta)
					e.delta = tmpray.t;
				if (e.delta < e.c)
				{
					e.b = e.c;
					e.c = e.delta;
					e.delta = e.b;
				}
			}
		}
		if (obj.size.y / 2 < length(ray->pos + ray->dir * e.c - obj.pos))
			return ;
	}
*/
// ray->otherside n est pas utilise, et le if verifie que le point de collision propose est valide.
// ray->t est la variable de retour qui comporte actuellement la derniere distance de collision calculee.
// Car on check tous les objets existants pour 1 rayon, donc on compare quel collision est la plus proche parmis tous les objets
// Donc e.c < ray->t
	ray->otherside = e.delta - e.c;
	if (e.c > 0.0000001 && e.c < ray->t)
		ray->t = e.c;
}

static double2		ft_cone_text_coords(const t_vector hit, const __global t_object *obj)
{
	// double2		c = {
	// 	, \
		
	// };
}
