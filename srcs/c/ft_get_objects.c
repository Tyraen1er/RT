/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_get_objects.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/11/30 18:19:27 by bmoiroud          #+#    #+#             */
/*   Updated: 2018/01/11 18:05:48 by eferrand         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void	ft_get_object(char **tab, t_data *data, int *i, int j[12])
{
	int		k;

	k = data->rt.nb_obj;
	if (ft_strcmp(tab[(*i)], "position") == 0 && !j[0])
		j[0] = ft_get_coord(tab, &data->rt.objects[k].pos, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "size") == 0 && !j[1])
		j[1] = ft_get_size(tab, &data->rt.objects[k].size, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "reflection") == 0 && !j[2])
		j[2] = ft_get_reflection(tab, &data->rt.objects[k].reflect, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "refraction") == 0 && !j[3])
		j[3] = ft_get_refraction(tab, &data->rt.objects[k].refract, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "opacity") == 0 && !j[4])
		j[4] = ft_get_opacity(tab, &data->rt.objects[k].transp, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "specularity") == 0 && !j[5])
		j[5] = ft_get_specularity(tab, &data->rt.objects[k].spec, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "perturbation") == 0 && !j[6])
		j[6] = ft_get_perturbation(tab, &data->rt.objects[k].np, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "texture") == 0 && !j[7])
		j[7] = ft_get_texture(tab, &data->rt.objects[k], i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "color") == 0 && !j[8])
		j[8] = ft_get_color(tab, &data->rt.objects[k].color, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "orientation") == 0 && !j[9])
		j[9] = ft_get_rotation(tab, &data->rt.objects[k].rot, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "translation") == 0 && j[0])
		ft_translation(tab, &data->rt.objects[k].pos, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "noise") == 0 && !j[10])
		j[10] = ft_get_noise(tab, &data->rt.objects[k].noise, i, &data->rt.line);
	else if (ft_strcmp(tab[(*i)], "negative") == 0 && !j[11])
		j[11] = ft_get_negative(tab, &data->rt.objects[k].negative, i, &data->rt.line);
	else if (!ft_comment(tab[(*i)]) && ft_strcmp(tab[(*i)], "-") != 0)
		ft_error(2, data->rt.line);
}

void	ft_get_sphere(char **tab, t_data *data, int *i, int *line)
{
	int		j[12];
	int		k;

	k = data->rt.nb_obj;
	ft_bzero(&j, sizeof(j));
	data->rt.objects[k].type = SPHERE;
	while(ft_strcmp(tab[++(*i)], "/sphere") != 0)
	{
		data->rt.line = *line;
		if (ft_strcmp(tab[*i], "-") == 0)
			*line += 1;
		else
			ft_get_object(tab, data, i, j);
	}
	data->rt.nb_obj++;
	if (j[0] == 0)
	{
		ft_putstr("sphere position not set, ");
		ft_error(2, *line);
	}
	if (j[1] == 0)
	{
		ft_putstr("sphere size not set, ");
		ft_error(2, *line);
	}
}

void	ft_get_plane(char **tab, t_data *data, int *i, int *line)
{
	int		j[12];
	int		k;

	k = data->rt.nb_obj;
	ft_bzero(&j, sizeof(j));
	data->rt.objects[k].type = PLANE;
	while(ft_strcmp(tab[++(*i)], "/plane") != 0)
	{
		data->rt.line = *line;
		if (ft_strcmp(tab[*i], "-") == 0)
			*line += 1;
		else
			ft_get_object(tab, data, i, j);
	}
	data->rt.nb_obj++;
	if (j[0] == 0)
	{
		ft_putstr("plane position not set, ");
		ft_error(2, *line);
	}
}

void	ft_get_cone(char **tab, t_data *data, int *i, int *line)
{
	int		j[12];
	int		k;

	k = data->rt.nb_obj;
	ft_bzero(&j, sizeof(j));
	data->rt.objects[k].type = CONE;
	while(ft_strcmp(tab[++(*i)], "/cone") != 0)
	{
		data->rt.line = *line;
		if (ft_strcmp(tab[*i], "-") == 0)
			*line += 1;
		else
			ft_get_object(tab, data, i, j);
	}
	data->rt.nb_obj++;
	if (j[0] == 0)
	{
		ft_putstr("cone position not set, ");
		ft_error(2, *line);
	}
	if (j[1] == 0)
	{
		ft_putstr("cone size not set, ");
		ft_error(2, *line);
	}
}

void	ft_get_cylinder(char **tab, t_data *data, int *i, int *line)
{
	int		j[12];
	int		k;

	k = data->rt.nb_obj;
	ft_bzero(&j, sizeof(j));
	data->rt.objects[k].type = CYLINDER;
	while(ft_strcmp(tab[++(*i)], "/cylinder") != 0)
	{
		data->rt.line = *line;
		if (ft_strcmp(tab[*i], "-") == 0)
			*line += 1;
		else
			ft_get_object(tab, data, i, j);
	}
	data->rt.nb_obj++;
	if (j[0] == 0)
	{
		ft_putstr("cylinder position not set, ");
		ft_error(2, *line);
	}
	if (j[1] == 0)
	{
		ft_putstr("cylinder size not set, ");
		ft_error(2, *line);
	}
}
